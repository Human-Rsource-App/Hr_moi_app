import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionScreen extends StatefulWidget {
  final CameraDescription camera;
  const FaceDetectionScreen({super.key, required this.camera});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  bool _photoTaken = false;
  XFile? _capturedImage;
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableTracking: false,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    await _controller.initialize();
    await _controller.startImageStream(_processCameraImage);
    setState(() {});
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting || _photoTaken) return;
    _isDetecting = true;

    try {
      final rotation = _rotationIntToImageRotation(
        widget.camera.sensorOrientation,
      );
      final inputImage = _cameraImageToInputImage(image, rotation);
      final faces = await _faceDetector.processImage(inputImage);

      setState(() {
        _faces = faces;
      });

      if (faces.isNotEmpty && !_photoTaken) {
        _photoTaken = true;
        final XFile file = await _controller.takePicture();
        setState(() {
          _capturedImage = file;
        });
      }
    } catch (e) {
      print("Face detection error: $e");
    }

    _isDetecting = false;
  }

  InputImage _cameraImageToInputImage(
    CameraImage image,
    InputImageRotation rotation,
  ) {
    return InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.yuv420,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isFront = widget.camera.lensDirection == CameraLensDirection.front;

    return Scaffold(
      appBar: AppBar(title: const Text('Live Face Detection & Auto Capture')),
      body: _capturedImage == null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: isFront
                      ? Matrix4.rotationY(math.pi)
                      : Matrix4.identity(),
                  child: CameraPreview(_controller),
                ),
                CustomPaint(painter: FacePainter(_faces, isFront)),
              ],
            )
          : Center(child: Image.file(File(_capturedImage!.path))),
      floatingActionButton: _capturedImage != null
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _capturedImage = null;
                  _faces = [];
                  _photoTaken = false;
                  _controller.startImageStream(_processCameraImage);
                });
              },
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final bool isFront;
  FacePainter(this.faces, this.isFront);

  @override
  void paint(Canvas canvas, Size size) {
    final paintRect = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final paintPoints = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (var face in faces) {
      Rect rect = face.boundingBox;

      if (isFront) {
        rect = Rect.fromLTRB(
          size.width - rect.right,
          rect.top,
          size.width - rect.left,
          rect.bottom,
        );
      }

      canvas.drawRect(rect, paintRect);

      for (var contour in face.contours.values) {
        if (contour == null) continue;
        for (var point in contour.points) {
          double x = point.x.toDouble();
          double y = point.y.toDouble();
          if (isFront) x = size.width - x;
          canvas.drawCircle(Offset(x, y), 2, paintPoints);
        }
      }

      if (face.smilingProbability != null) {
        final smile = (face.smilingProbability! * 100).toStringAsFixed(0);
        final textPainter = TextPainter(
          text: TextSpan(
            text: "Smile: $smile%",
            style: const TextStyle(color: Colors.yellow, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(rect.left, rect.top - 20));
      }

      if (face.leftEyeOpenProbability != null &&
          face.rightEyeOpenProbability != null) {
        final left = (face.leftEyeOpenProbability! * 100).toStringAsFixed(0);
        final right = (face.rightEyeOpenProbability! * 100).toStringAsFixed(0);
        final textPainter = TextPainter(
          text: TextSpan(
            text: "Eyes L:$left% R:$right%",
            style: const TextStyle(color: Colors.blue, fontSize: 14),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(rect.left, rect.bottom + 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
