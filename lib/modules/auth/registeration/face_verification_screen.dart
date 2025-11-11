import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hr_moi/shared/components/components.dart';
import 'package:hr_moi/shared/components/constants.dart';
import 'package:hr_moi/shared/cubit/cubit.dart';
import 'package:hr_moi/shared/cubit/states.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  bool _cameraInitialized = false;
  CameraDescription? _camera;
  FaceDetector? _faceDetector;
  Face? currentFace;
  Timer? _frameTimer;
  bool _processing = false;
  XFile? _capturedImage;
  DateTime? _faceStableSince;
  Size? _previewSize;

  final double _stableDurationSeconds = 2.0;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  bool faceInsideOval = false;
  String _hintText = "قم بمحاذاة وجهك داخل الشكل مع الحفاظ على اضاءة جيدة ";

  @override
  void initState() {
    super.initState();
    _initCamera();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _colorAnimation =
        ColorTween(
          begin: Colors.red,
          end: Colors.green,
        ).animate(_animationController)..addListener(() {
          setState(() {});
        });
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      _camera!,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    _cameraInitialized = true;
    _previewSize = _cameraController!.value.previewSize;

    _frameTimer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) => _captureFrameForDetection(),
    );

    if (mounted) setState(() {});
  }

  Rect _getOvalRect(Size size) {
    final double width = size.width * 0.7;
    final double height = size.height * 0.5;
    final double left = (size.width - width) / 2;
    final double top = (size.height - height) / 2;
    return Rect.fromLTWH(left, top, width, height);
  }

  bool _isFaceInsideOval(Face face, Size widgetSize) {
    final ovalRect = _getOvalRect(widgetSize);

    final scaleX = widgetSize.width / (_previewSize?.width ?? widgetSize.width);
    final scaleY =
        widgetSize.height / (_previewSize?.height ?? widgetSize.height);

    double left = face.boundingBox.left * scaleX;
    double top = face.boundingBox.top * scaleY;
    double right = face.boundingBox.right * scaleX;
    double bottom = face.boundingBox.bottom * scaleY;

    final faceCenterX = (left + right) / 2;
    final faceCenterY = (top + bottom) / 2;

    final a = ovalRect.width / 2;
    final b = ovalRect.height / 2;
    final cx = ovalRect.left + a;
    final cy = ovalRect.top + b;

    final value =
        ((faceCenterX - cx) * (faceCenterX - cx)) / (a * a) +
        ((faceCenterY - cy) * (faceCenterY - cy)) / (b * b);

    return value <= 1.0;
  }

  Future<void> _captureFrameForDetection() async {
    if (_processing) return;
    if (!_cameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }
    _processing = true;

    try {
      final file = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final faces = await _faceDetector!.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        currentFace = face;

        if (_previewSize != null) {
          final widgetSize = MediaQuery.of(context).size;
          final inside = _isFaceInsideOval(face, widgetSize);
          faceInsideOval = inside;

          if (inside) {
            _animationController.forward();
            _hintText = "رجاءا ثبت الهاتف ...";

            _faceStableSince ??= DateTime.now();

            final stableDuration = DateTime.now()
                .difference(_faceStableSince!)
                .inMilliseconds;
            if (stableDuration >= (_stableDurationSeconds * 1000) &&
                _capturedImage == null) {
              _capturedImage = await _cameraController!.takePicture();
              _hintText = "Captured!";
              _navigateToResult(_capturedImage!);
            }
          } else {
            _animationController.reverse();
            _faceStableSince = null;
            _hintText = "قم بتقريب وابعاد الكامرة لافضل صورة";
          }
        }
      } else {
        currentFace = null;
        _faceStableSince = null;
        faceInsideOval = false;
        _animationController.reverse();
        _hintText = "قم بمحاذاة وجهك داخل الشكل مع الحفاظ على اضاءة جيدة";
      }

      try {
        await File(file.path).delete();
      } catch (_) {}
    } catch (e) {
      if (mounted) showMessage(context: context, message: 'Error: $e');
    } finally {
      _processing = false;
    }
  }

  void _navigateToResult(XFile image) {
    try {
      _frameTimer?.cancel();
    } catch (_) {}
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DisplayImagePage(imagePath: image.path),
      ),
    );
  }

  @override
  void dispose() {
    try {
      _frameTimer?.cancel();
    } catch (_) {}
    try {
      _cameraController?.dispose();
    } catch (_) {}
    _faceDetector?.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final preview = CameraPreview(_cameraController!);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final widgetSize = constraints.biggest;

          return Stack(
            children: [
              preview,
              Positioned.fill(
                child: CustomPaint(
                  painter: _OvalGuidePainter(
                    widgetSize: widgetSize,
                    color: _colorAnimation.value ?? Colors.red,
                  ),
                ),
              ),
              // Hint text
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _hintText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OvalGuidePainter extends CustomPainter {
  final Size widgetSize;
  final Color color;
  _OvalGuidePainter({required this.widgetSize, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = color;

    final double width = size.width * 0.7;
    final double height = size.height * 0.5;
    final double left = (size.width - width) / 2;
    final double top = (size.height - height) / 2;

    final rect = Rect.fromLTWH(left, top, width, height);
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _OvalGuidePainter oldDelegate) =>
      oldDelegate.color != color;
}

class DisplayImagePage extends StatelessWidget {
  final String imagePath;
  const DisplayImagePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    String image64Trans({required String imagePath}) {
      final personalImage = File(imagePath);
      List<int> personalImageByte = personalImage.readAsBytesSync();
      final personalImageBase64 = base64Encode(personalImageByte);
      return personalImageBase64;
    }

    return BlocConsumer<HrMoiCubit, HrMoiStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HrMoiCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.file(File(imagePath)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: defaultButton(
                      context: context,
                      lable: 'استمرار',
                      onPressed: () {
                        var stringImage = image64Trans(imagePath: imagePath);
                        print(stringImage);
                        cubit.postUserFace(
                          url: '$baseUrl$faceUrl$hrNum'.toString(),
                          data: stringImage,
                          context: context,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
