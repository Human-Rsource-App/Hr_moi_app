import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcReaderScreen extends StatefulWidget {
  const NfcReaderScreen({super.key});

  @override
  State<NfcReaderScreen> createState() => _NfcReaderScreenState();
}

class _NfcReaderScreenState extends State<NfcReaderScreen> {
  String _scanResult = 'Press "Start Scan" to read an NFC card.';

  Future<void> _startScan() async {
    setState(() {
      _scanResult = 'Scanning... Hold your Iraqi ID card near the phone.';
    });

    try {
      NFCTag tag = await FlutterNfcKit.poll();

      if (tag.type == NFCTagType.iso7816) {
        setState(() {
          _scanResult =
              'ISO 7816 compatible tag detected. Attempting to send APDU...';
        });

        // WARNING: This is a GENERIC, NON-FUNCTIONAL command.
        // You cannot use this to read the Iraqi ID card.
        // It will fail because the card requires authentication.
        // A real-world application would require a specific, licensed SDK.
        String apduCommand = "00A404000411AA22BB"; // Example Select command

        try {
          String apduResponse = await FlutterNfcKit.transceive(apduCommand);
          setState(() {
            _scanResult = 'Command sent. Received response: $apduResponse';
          });
        } catch (e) {
          setState(() {
            _scanResult = 'Failed to send APDU command: $e';
          });
        }
      } else {
        setState(() {
          _scanResult = 'Detected tag is not an ISO 7816 type.';
        });
      }
    } catch (e) {
      setState(() {
        _scanResult = 'NFC scan failed: $e';
      });
    }

    await FlutterNfcKit.finish();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _scanResult,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _startScan,
            child: const Text('Start Scan'),
          ),
        ],
      ),
    );
  }
}
