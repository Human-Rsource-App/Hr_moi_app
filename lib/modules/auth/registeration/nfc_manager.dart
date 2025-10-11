import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcPage extends StatefulWidget {
  @override
  _NfcPageState createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  static const methodChannel = MethodChannel('nfc/methods');
  static const eventChannel = EventChannel('nfc/events');

  String _log = '';
  StreamSubscription? _eventSub;
  bool _nfcAvailable = false;

  void _append(String s) => setState(() => _log = '$_log\n$s');

  @override
  void initState() {
    super.initState();
    _checkAvailability();
    _eventSub = eventChannel.receiveBroadcastStream().listen(
      (event) {
        _append('Event: $event');
      },
      onError: (e) {
        _append('Event error: $e');
      },
    );
  }

  Future<void> _checkAvailability() async {
    bool avail = await NfcManager.instance.isAvailable();
    setState(() => _nfcAvailable = avail);
    _append('NFC available: $avail');
  }

  Future<void> _startNativeListening() async {
    try {
      final ok = await methodChannel.invokeMethod('startListening');
      _append('Started native listening: $ok');
    } on PlatformException catch (e) {
      _append('startListening error: ${e.message}');
    }
  }

  Future<void> _stopNativeListening() async {
    try {
      final ok = await methodChannel.invokeMethod('stopListening');
      _append('Stopped native listening: $ok');
    } on PlatformException catch (e) {
      _append('stopListening error: ${e.message}');
    }
  }

  // مثال: إرسال APDU SELECT AID (جرب استبدال الـ AID بما يلزم)
  Future<void> _sendSelectApdu() async {
    // مثال AID: A0 00 00 00 00 00 00 (استبدل حسب البطاقة)
    final selectApdu = <int>[
      0x00, 0xA4, 0x04, 0x00, // CLA INS P1 P2
      0x07, // Lc
      0xA0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // AID bytes
    ];
    try {
      final Uint8List arg = Uint8List.fromList(selectApdu);
      final String respHex = await methodChannel.invokeMethod('sendApdu', arg);
      _append('APDU response: $respHex');
    } on PlatformException catch (e) {
      _append('sendApdu error: ${e.message}');
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NFC IsoDep (Native)')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text('NFC available: $_nfcAvailable'),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _startNativeListening,
                  child: Text('Start Listening (Native)'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _stopNativeListening,
                  child: Text('Stop'),
                ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sendSelectApdu,
              child: Text('Send SELECT APDU (example)'),
            ),
            SizedBox(height: 12),
            Expanded(child: SingleChildScrollView(child: Text(_log))),
          ],
        ),
      ),
    );
  }
}
