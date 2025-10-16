import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({required this.camera, super.key});
  @override
  State createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool ready = false;
  bool scanning = false;
  bool autoScanning = false;
  String result = '';

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => ready = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File> _takePictureFile() async {
    final tmp = await _controller.takePicture();
    return File(tmp.path);
  }

  Future<File> _cropToMrzArea(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return imageFile;
    final h = decoded.height;
    final w = decoded.width;

    // crop the middle area (MRZ region)
    final cropH = (h * 0.35).round();
    final startY = ((h - cropH) / 2).round();
    final cropped = img.copyCrop(
      decoded,
      x: 0,
      y: startY,
      width: w,
      height: cropH,
    );
    final tmpDir = await getTemporaryDirectory();
    final out = File('${tmpDir.path}/mrz_crop.jpg');
    await out.writeAsBytes(img.encodeJpg(cropped, quality: 90));
    return out;
  }

  String normalizeMrz(String s) {
    return s
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll('—', '<')
        .replaceAll('⋯', '<')
        .replaceAll('·', '<')
        .replaceAll('«', '<')
        .replaceAll('»', '<')
        .replaceAll('O', '0')
        .toUpperCase();
  }

  Future<void> scanOnce() async {
    if (scanning) return;
    scanning = true;
    setState(() => result = 'Scanning...');

    try {
      final photo = await _takePictureFile();
      final crop = await _cropToMrzArea(photo);
      final inputImage = InputImage.fromFile(crop);
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognized = await recognizer.processImage(inputImage);
      await recognizer.close();

      final lines = recognized.blocks
          .expand((b) => b.lines)
          .map((l) => normalizeMrz(l.text))
          .where((t) => t.isNotEmpty)
          .toList();

      final mrzLike = lines
          .where((l) => l.length >= 28 && RegExp(r'^[A-Z0-9<]+$').hasMatch(l))
          .toList();

      final candidates = <List<String>>[];
      for (int i = 0; i + 2 < mrzLike.length; i++) {
        final l1 = mrzLike[i], l2 = mrzLike[i + 1], l3 = mrzLike[i + 2];
        final avg = (l1.length + l2.length + l3.length) / 3;
        if ((l1.length - avg).abs() < 5 &&
            (l2.length - avg).abs() < 5 &&
            (l3.length - avg).abs() < 5) {
          candidates.add([l1, l2, l3]);
        }
      }

      Map<String, String>? parsed;
      for (final c in candidates) {
        parsed = tryParseMrz(c);
        if (parsed.isNotEmpty) break;
      }

      setState(() {
        if (parsed == null || parsed.isEmpty) {
          result = 'No MRZ detected yet...';
        } else {
          result = parsed.entries.map((e) => '${e.key}: ${e.value}').join('\n');
        }
      });

      if (parsed != null && parsed.isNotEmpty) {
        autoScanning = false; // stop auto mode
      }
    } catch (e) {
      setState(() => result = 'Error: $e');
    } finally {
      scanning = false;
    }
  }

  void startAutoScan() async {
    if (autoScanning) return;
    autoScanning = true;
    setState(() => result = 'Auto scanning... Align MRZ with mask');

    while (autoScanning && mounted) {
      await scanOnce();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(_controller)),
          Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: MrzMaskPainter())),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  onPressed: scanning ? null : startAutoScan,
                  child: Text(scanning ? 'Scanning...' : 'Start Auto Scan'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () => setState(() {
                    result = '';
                    autoScanning = false;
                  }),
                  child: const Text('Stop / Clear'),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Text(
                      result,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// --- MRZ Mask Painter (Centered & Larger) ---
class MrzMaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black54;

    final cutWidth = size.width * 0.9;
    final cutHeight = size.height * 0.4;
    final left = (size.width - cutWidth) / 2;
    final top = (size.height - cutHeight) / 2;
    final rect = Rect.fromLTWH(left, top, cutWidth, cutHeight);

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(RRect.fromRectXY(rect, 12, 12)),
    );
    canvas.drawPath(path, overlayPaint);

    final border = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(RRect.fromRectXY(rect, 12, 12), border);

    const maskLines = [
      'IDIRQC872855450199168716848<<<',
      '9104255M3209103IRQ<<<<<<<<<<<6',
      '<<XAEYMN<<<<<<<<<<<<<<<<<<<<<<',
    ];

    void textPainter(String text, double y) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.white70,
            fontFamily: 'monospace',
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: cutWidth);
      tp.paint(canvas, Offset(left + 15, y));
    }

    final lineSpacing = 26.0;
    for (int i = 0; i < maskLines.length; i++) {
      textPainter(maskLines[i], top + (cutHeight / 2 - 25) + i * lineSpacing);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// --- MRZ Parsing ---

Map<String, String> tryParseMrz(List<String> lines) {
  if (lines.length == 3 && lines.every((l) => l.length >= 30)) {
    return parseTd1(lines);
  }
  if (lines.length == 2 && lines[0].length >= 36 && lines[1].length >= 36) {
    if (lines[0].length >= 44) return parseTd3(lines);
    return parseTd2(lines);
  }
  return {};
}

Map<String, String> parseTd1(List<String> l) {
  final a = l[0].padRight(30, '<');
  final b = l[1].padRight(30, '<');
  final c = l[2].padRight(30, '<');
  final docType = a.substring(0, 2);
  final country = a.substring(2, 5);
  final docNum = a.substring(5, 14).replaceAll('<', '');
  final birth = b.substring(0, 6);
  final sex = b.substring(7, 8);
  final expiry = b.substring(8, 14);
  final nationality = b.substring(15, 18);
  final optional = b.substring(18, 29).replaceAll('<', '');
  final names = parseNames(c);

  return {
    'Format': 'TD1 (ID Card)',
    'Document Type': docType,
    'Issuing Country': country,
    'Document Number': docNum,
    'Date of Birth': formatDate(birth),
    'Sex': sex,
    'Expiry Date': formatDate(expiry),
    'Nationality': nationality,
    'Optional Number': optional,
    'Name': '${names['surname']} ${names['given']}',
  };
}

Map<String, String> parseTd2(List<String> l) {
  final a = l[0].padRight(36, '<');
  final b = l[1].padRight(36, '<');
  final docType = a.substring(0, 2);
  final country = a.substring(2, 5);
  final names = parseNames(a.substring(5));
  final docNum = b.substring(0, 9).replaceAll('<', '');
  final nationality = b.substring(10, 13);
  final birth = b.substring(13, 19);
  final sex = b.substring(20, 21);
  final expiry = b.substring(21, 27);

  return {
    'Format': 'TD2 (Residence Card)',
    'Document Type': docType,
    'Issuing Country': country,
    'Document Number': docNum,
    'Nationality': nationality,
    'Date of Birth': formatDate(birth),
    'Sex': sex,
    'Expiry Date': formatDate(expiry),
    'Name': '${names['surname']} ${names['given']}',
  };
}

Map<String, String> parseTd3(List<String> l) {
  final a = l[0].padRight(44, '<');
  final b = l[1].padRight(44, '<');
  final docType = a.substring(0, 2);
  final country = a.substring(2, 5);
  final names = parseNames(a.substring(5));
  final docNum = b.substring(0, 9).replaceAll('<', '');
  final nationality = b.substring(10, 13);
  final birth = b.substring(13, 19);
  final sex = b.substring(20, 21);
  final expiry = b.substring(21, 27);

  return {
    'Format': 'TD3 (Passport)',
    'Document Type': docType,
    'Issuing Country': country,
    'Document Number': docNum,
    'Nationality': nationality,
    'Date of Birth': formatDate(birth),
    'Sex': sex,
    'Expiry Date': formatDate(expiry),
    'Name': '${names['surname']} ${names['given']}',
  };
}

Map<String, String> parseNames(String s) {
  final parts = s.split('<<');
  final surname = parts.isNotEmpty ? parts[0].replaceAll('<', ' ') : '';
  final given = parts.length > 1 ? parts[1].replaceAll('<', ' ') : '';
  return {'surname': surname.trim(), 'given': given.trim()};
}

String formatDate(String yymmdd) {
  if (yymmdd.length != 6) return yymmdd;
  return '20${yymmdd.substring(0, 2)}-${yymmdd.substring(2, 4)}-${yymmdd.substring(4, 6)}';
}
