import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart' as mlkit;
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class FaceLivenessPage extends StatefulWidget {
  const FaceLivenessPage({super.key});

  @override
  State<FaceLivenessPage> createState() => _FaceLivenessPageState();
}

class _FaceLivenessPageState extends State<FaceLivenessPage> {
  CameraController? _controller;
  late FaceDetector _faceDetector;
  Timer? _frameTimer;
  bool _isProcessing = false;
  bool _livenessPassed = false;
  String _status = 'Initializing camera...';
  bool _flashOverlay = false;
  final player = AudioPlayer();

  File? _verifiedImage; // هنا سنخزن الصورة النهائية للتحقق

  final List<String> _challenges = [
    'ارمش',
    'استدر لليمين',
    'استدر لليسار',
    'ابتسم',
  ];
  int _challengeIndex = 0;

  String get _currentChallenge => _challenges[_challengeIndex];

  @override
  void initState() {
    super.initState();
    _initFaceDetector();
    _startCamera();
  }

  void _initFaceDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        enableTracking: true,
        enableLandmarks: true,
      ),
    );
  }

  Future<void> _startCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    await _controller!.initialize();

    _startFaceStream();
    setState(() => _status = 'اضبط وجهك داخل الدائرة وابدأ التحديات');
  }

  void _startFaceStream() {
    _frameTimer?.cancel();
    _frameTimer = Timer.periodic(const Duration(milliseconds: 600), (_) async {
      if (_isProcessing || _livenessPassed) return;
      _isProcessing = true;

      try {
        final file = await _controller!.takePicture();

        final input = mlkit.InputImage.fromFilePath(file.path);
        final faces = await _faceDetector.processImage(input);

        if (faces.isNotEmpty) {
          _evaluateFace(faces.first, file);
        } else {
          setState(() => _status = 'لا يوجد وجه. حاول مرة أخرى.');
        }
      } catch (_) {
      } finally {
        _isProcessing = false;
      }
    });
  }

  void _evaluateFace(Face face, XFile file) {
    bool passed = false;

    switch (_currentChallenge) {
      case 'ارمش':
        passed =
            (face.leftEyeOpenProbability ?? 1) < 0.3 ||
            (face.rightEyeOpenProbability ?? 1) < 0.3;
        break;
      case 'استدر لليمين':
        passed = face.headEulerAngleY != null && face.headEulerAngleY! < -15;
        break;
      case 'استدر لليسار':
        passed = face.headEulerAngleY != null && face.headEulerAngleY! > 15;
        break;
      case 'ابتسم':
        passed = (face.smilingProbability ?? 0) > 0.7;
        break;
    }

    if (passed) {
      _nextChallenge(file);
    } else {
      setState(() => _status = 'قم: $_currentChallenge');
    }
  }

  Future<void> _nextChallenge(XFile file) async {
    if (_challengeIndex < _challenges.length - 1) {
      _challengeIndex++;
      await _playFeedback();
      setState(() => _status = 'جيد المرحله التالية: $_currentChallenge');
    } else {
      await _onLivenessSuccess(file);
    }
  }

  Future<void> _onLivenessSuccess(XFile file) async {
    _livenessPassed = true;
    _frameTimer?.cancel();

    _verifiedImage = File(file.path); // حفظ الصورة النهائية

    setState(() => _status = '✔ تم التحقق من الحيوية بنجاح!');
    await _playFeedback();
  }

  Future<void> _playFeedback() async {
    setState(() => _flashOverlay = true);
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() => _flashOverlay = false);
    await player.play(AssetSource('sounds/success.mp3'));
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _controller?.dispose();
    _faceDetector.close();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HrMoiCubit cubit = HrMoiCubit.get(context);
    return BlocConsumer<HrMoiCubit, HrMoiStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.center,
              children: [
                if (_controller != null && _controller!.value.isInitialized)
                  CameraPreview(_controller!),

                CustomPaint(painter: _OvalPainter(), child: Container()),

                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!_livenessPassed)
                  Positioned(
                    bottom: 60,
                    child: Text(
                      'خطوة ${_challengeIndex + 1} من ${_challenges.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),

                if (_livenessPassed)
                  Positioned(
                    bottom: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_verifiedImage != null) {
                          var stringImage = image64Trans(
                            imagePath: _verifiedImage!.path,
                          );

                          cubit.postUserFace(
                            url: '$baseUrl$faceUrl$hrNum'.toString(),
                            data: stringImage,
                            context: context,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 14,
                        ),
                      ),
                      child: const Text(
                        "تابع التسجيل",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                if (_flashOverlay)
                  Container(color: Colors.white.withValues(alpha: .8)),
              ],
            ),
          ),
        );
      },
    );
  }

  String image64Trans({required String imagePath}) {
    final personalImage = File(imagePath);
    List<int> personalImageByte = personalImage.readAsBytesSync();
    final personalImageBase64 = base64Encode(personalImageByte);
    return personalImageBase64;
  }
}

class _OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintOverlay = Paint()
      ..color = Colors.black.withValues(alpha: .6)
      ..style = PaintingStyle.fill;

    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final ovalPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2.3),
          width: size.width * 0.7,
          height: size.height * 0.5,
        ),
      );

    final overlay = Path.combine(PathOperation.difference, fullPath, ovalPath);
    canvas.drawPath(overlay, paintOverlay);

    final border = Paint()
      ..color = Colors.white.withValues(alpha: .9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawPath(ovalPath, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
