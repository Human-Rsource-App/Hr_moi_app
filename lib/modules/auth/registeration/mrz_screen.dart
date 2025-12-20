import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:camera/camera.dart';

import '../../../generated/assets.dart';
import '../../../shared/style/color.dart';

class CameraScreen extends StatefulWidget
{
    final CameraDescription camera;
    const CameraScreen({required this.camera, super.key});
    @override
    State createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
{
    late CameraController _controller;
    bool ready = false;
    bool scanning = false;
    bool autoScanning = false;
    String result = '';

    @override
    void initState()
    {
        super.initState();
        _controller = CameraController(
            widget.camera,
            ResolutionPreset.high,
            enableAudio: false,
            imageFormatGroup: ImageFormatGroup.jpeg
        );
        _controller.initialize().then((_)
            {
                if (!mounted) return;
                setState(() => ready = true);
            }
        );
    }

    @override
    void dispose()
    {
        _controller.dispose();
        super.dispose();
    }

    Future<File> _takePictureFile() async
    {
        final tmp = await _controller.takePicture();
        return File(tmp.path);
    }

    Future<File> _cropToMrzArea(File imageFile) async
    {
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
            height: cropH
        );
        final tmpDir = await getTemporaryDirectory();
        final out = File('${tmpDir.path}/mrz_crop.jpg');
        await out.writeAsBytes(img.encodeJpg(cropped, quality: 90));
        return out;
    }

    String normalizeMrz(String s)
    {
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

    Future<void> scanOnce() async
    {
        if (scanning) return;
        scanning = true;
        setState(() => result = 'جاري المسح...');

        try
        {
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
            for (int i = 0; i + 2 < mrzLike.length; i++)
            {
                final l1 = mrzLike[i], l2 = mrzLike[i + 1], l3 = mrzLike[i + 2];
                final avg = (l1.length + l2.length + l3.length) / 3;
                if ((l1.length - avg).abs() < 5 &&
                    (l2.length - avg).abs() < 5 &&
                    (l3.length - avg).abs() < 5)
                {
                    candidates.add([l1, l2, l3]);
                }
            }

            Map<String, String>? parsed;
            for (final c in candidates)
            {
                parsed = tryParseMrz(c);
                if (parsed.isNotEmpty) break;
            }

            setState(()
                {
                    if (parsed == null || parsed.isEmpty)
                    {
                        result = 'لم يتم اكتشاف MRZ حتى الآن...';
                    }
                    else
                    {
                        result = parsed.entries.map((e) => '${e.key}: ${e.value}').join('\n');
                    }
                }
            );

            if (parsed != null && parsed.isNotEmpty)
            {
                autoScanning = false; // stop auto mode
            }
        }
        catch (e)
        {
            setState(() => result = 'Error: $e');
        }
        finally
        {
            scanning = false;
        }
    }

    void startAutoScan() async
    {
        if (autoScanning) return;
        autoScanning = true;
        setState(() => result = 'المسح التلقائي... محاذاة MRZ مع القناع');

        while (autoScanning && mounted)
        {
            await scanOnce();
            await Future.delayed(const Duration(seconds: 1));
        }
    }

    @override
    Widget build(BuildContext context)
    {
        if (!ready)
        {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Directionality(
            textDirection: TextDirection.rtl,
            child: BlocConsumer<HrMoiCubit, HrMoiStates>(
                listener: (context, state)
                {
                },
                builder: (context, state)
                {
                  final Size size = MediaQuery.of(context).size;
                    var cubit = HrMoiCubit.get(context);
                    return Scaffold(
                        body: Container(

                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: backGrColor,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter
                              )
                          ),
                          width: size.width,
                          height: size.height,
                          child: Stack(


                              children: [
                                  Positioned.fill(child:autoScanning? CameraPreview(_controller):SizedBox.shrink()),
                                  Positioned.fill(

                                      child:  autoScanning?IgnorePointer(
                                          child:CustomPaint(painter: MrzMaskPainter())

                                      ): Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child:GestureDetector(onTap:scanning ? null : startAutoScan, child: Image.asset(Assets.iconsScanid,fit: BoxFit.contain, ))
                                      ),
                                  ),
                                  Positioned(
                                      bottom: 8,
                                      left: 20,
                                      right: 20,
                                      child: Column(
                                          children: [

                                              !autoScanning && result.isNotEmpty ? Container(
                                                      width: double.infinity,
                                                    //  color: Colors.black54,
                                                      padding: const EdgeInsets.all(8),
                                                      child: SingleChildScrollView(
                                                          child:Image.asset(Assets.iconsChecked,width: 60.0,height: 60.0,),
                                                          // Text(
                                                          //     result,
                                                          //     style: const TextStyle(
                                                          //         color: Colors.white,
                                                          //         fontSize: 14
                                                          //     )
                                                          // )
                                                      )
                                                  ) : SizedBox.shrink()

                                          ]
                                      )
                                  )
                              ]
                          ),
                        ),
                        bottomNavigationBar: Container(

                            decoration: BoxDecoration(

                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: backGrColor
                                )
                            ),
                            child: Column(
                                spacing: 5.0,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    SizedBox(height: 10.0),
                                    IconButton(onPressed: scanning ? null : startAutoScan, icon: Image.asset(Assets.userProfileMrz, width: 30.0, height: 30.0)),
                                    Text('امسح الرمز في الوجه الخلفي للبطاقة الوطنية', style: TextTheme.of(context).bodySmall),
                                    Text('يرجى محاذاة البطاقة الوطنية داخل الاطار', style: TextTheme.of(context).bodySmall!.copyWith(color: Colors.grey)),
                                    Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: defaultButton(context: context, onPressed: !autoScanning && result.isNotEmpty ? ()
                                                {
                                                    cubit.getNationalId(
                                                        url: '$baseUrl$mrzUrl$nID',
                                                        context: context
                                                    );
                                                }
                                                : null, lable: 'متابعة')
                                    )

                                ]
                            )
                        )

                    );
                }
            )
        );
    }
}

/// --- MRZ Mask Painter (Centered & Larger) ---
class MrzMaskPainter extends CustomPainter
{
    @override
    void paint(Canvas canvas, Size size)
    {
        final overlayPaint = Paint()..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backGrColor
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

        final cutWidth = size.width * 0.92;
        final cutHeight = size.height * 0.5;
        final left = (size.width - cutWidth) / 2;
        final top = (size.height - cutHeight) / 2;
        final rect = Rect.fromLTWH(left, top, cutWidth, cutHeight);

        final path = Path.combine(
            PathOperation.difference,
            Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
            Path()..addRRect(RRect.fromRectXY(rect, 12, 12))
        );
        canvas.drawPath(path, overlayPaint);

        final border = Paint()
            ..color = Colors.orange
            ..strokeWidth = 2.5
            ..style = PaintingStyle.stroke;
        canvas.drawRRect(RRect.fromRectXY(rect, 12, 12), border);

        const maskLines = [
            'IDIRQC871853450100167716848<<<',
            '4108255M3009107IRQ<<<<<<<<<<<6',
            '<<XAEYMN<<<<<<<<<<<<<<<<<<<<<<'
        ];

        void textPainter(String text, double y)
        {
            final tp = TextPainter(
                text: TextSpan(
                    text: text,
                    style: const TextStyle(
                        color: Colors.orange,
                        fontFamily: 'monospace',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5
                    )
                ),
                textDirection: TextDirection.ltr
            );
            tp.layout(maxWidth: cutWidth);
            tp.paint(canvas, Offset(left + 11, y));
        }

        final lineSpacing = 26.0;
        for (int i = 0; i < maskLines.length; i++)
        {
            textPainter(maskLines[i], top + (cutHeight / 2 - 25) + i * lineSpacing);
        }
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// --- MRZ Parsing ---

Map<String, String> tryParseMrz(List<String> lines)
{
    if (lines.length == 3 && lines.every((l) => l.length >= 30))
    {
        return parseTd1(lines);
    }

    return {};
}

Map<String, String> parseTd1(List<String> l)
{
    final a = l[0].padRight(30, '<');
    final b = l[1].padRight(30, '<');
    final c = l[2].padRight(30, '<');
    final docNum = a.substring(5, 14).replaceAll('<', '');
    nID = a.substring(15, 29).replaceAll('<', '');
    final birth = b.substring(0, 6);
    final expiry = b.substring(8, 14);
    final names = parseNames(c);

    return
    {
        'النوع': 'بطاقة وطنية عراقية',
        'رقم الوثيقة': docNum,
        'رقم الهوية': nID,
        'تاريخ الميلاد': formatDate(birth),
        'النفاذية': formatDate(expiry),
        'الاسم': '${names['surname']} ${names['given']}'
    };
}

Map<String, String> parseNames(String s)
{
    final parts = s.split('<<');
    final surname = parts.isNotEmpty ? parts[0].replaceAll('<', ' ') : '';
    final given = parts.length > 1 ? parts[1].replaceAll('<', ' ') : '';
    return {'surname': surname.trim(), 'given': given.trim()};
}

String formatDate(String yymmdd)
{
    if (yymmdd.length != 6) return yymmdd;
    return '${yymmdd.substring(0, 2)}-${yymmdd.substring(2, 4)}-${yymmdd.substring(4, 6)}';
}
