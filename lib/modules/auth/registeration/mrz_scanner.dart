import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mrz_scanner_plus/mrz_scanner_plus.dart';

class MRZScannerPage extends StatefulWidget {
  const MRZScannerPage({super.key});

  @override
  State<MRZScannerPage> createState() => _MRZScannerPageState();
}

class _MRZScannerPageState extends State<MRZScannerPage> {
  String? _imagePath;
  MRZResult? _mrzResult;
  bool _scanning = false;

  void _onMRZDetected(String imagePath, MRZResult mrzResult) {
    setState(() {
      _imagePath = imagePath;
      _mrzResult = mrzResult;
      _scanning = false;
    });
    debugPrint('MRZ image path: $imagePath');
    debugPrint('MRZ result: ${mrzResult.toJson()}');
  }

  void _onPhotoTaken(String imagePath) {
    setState(() {
      _imagePath = imagePath;
    });
    debugPrint('Photo taken: $imagePath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MRZ Scanner Plus')),
      body: Column(
        children: [
          Expanded(
            child: CameraView(
              mode: CameraMode.scan,
              onMRZDetected: _onMRZDetected,
              onPhotoTaken: _onPhotoTaken,
              onDetected: (text) {
                debugPrint('OCR raw text: $text');
              },
            ),
          ),
          if (_scanning) const LinearProgressIndicator(),
          if (_mrzResult != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_imagePath != null) Image.file(File(_imagePath!)),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Document number: ${_mrzResult!.documentNumber}',
                            ),
                            //Text('Nationality: ${_mrzResult!.nationality}'),
                            Text('Birth date: ${_mrzResult!.birthDate}'),
                            Text('Expiry date: ${_mrzResult!.expiryDate}'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _mrzResult = null;
                                  _imagePath = null;
                                });
                              },
                              child: const Text('Scan Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
