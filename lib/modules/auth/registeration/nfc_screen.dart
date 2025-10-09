import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter NFC Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NFCReaderScreen(),
    );
  }
}

class NFCReaderScreen extends StatefulWidget {
  const NFCReaderScreen({super.key});

  @override
  State<NFCReaderScreen> createState() => _NFCReaderScreenState();
}

class _NFCReaderScreenState extends State<NFCReaderScreen> {
  String _nfcTagId = 'No NFC tag detected';

  void _startNFCScan() async {
    try {
      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) {
          String tagId = 'Unknown tag type';

          try {
            // Platform-specific handling
            if (tag.data is Map) {
              final data = tag.data as Map;
              if (data['nfca'] != null && data['nfca']['identifier'] != null) {
                final idBytes = List<int>.from(data['nfca']['identifier']);
                tagId = idBytes
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':');
              } else if (data['mifareclassic'] != null &&
                  data['mifareclassic']['identifier'] != null) {
                final idBytes = List<int>.from(
                  data['mifareclassic']['identifier'],
                );
                tagId = idBytes
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':');
              } else if (data['iso7816'] != null &&
                  data['iso7816']['identifier'] != null) {
                final idBytes = List<int>.from(data['iso7816']['identifier']);
                tagId = idBytes
                    .map((e) => e.toRadixString(16).padLeft(2, '0'))
                    .join(':');
              }
            }
          } catch (e) {
            tagId = 'Error reading tag: $e';
          }

          setState(() {
            _nfcTagId = tagId;
          });

          // Stop session
          NfcManager.instance.stopSession();
        },
      );
    } catch (e) {
      setState(() {
        _nfcTagId = 'NFC Session error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC Reader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _nfcTagId,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNFCScan,
              child: const Text('Scan NFC Tag'),
            ),
          ],
        ),
      ),
    );
  }
}
