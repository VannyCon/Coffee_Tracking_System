import 'package:coffee_tracker/plugins/plant_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NfcReader extends StatefulWidget {
  final ThemeData? theme;

  const NfcReader({Key? key, required this.theme}) : super(key: key);
  @override
  _NfcReaderState createState() => _NfcReaderState();
}

class _NfcReaderState extends State<NfcReader> {
  String _nfcData = "Scan an NFC tag";

  @override
  void initState() {
    super.initState();
    _readNfc(); // Trigger NFC scan automatically
  }

  Future<void> _readNfc() async {
    try {
      // Start NFC polling
      var nfcTag = await FlutterNfcKit.poll();
      if (nfcTag != null) {
        setState(() {
          _nfcData = 'NFC Tag ID: ${nfcTag.id}';
          PlantInfo.showInputDialog(
              context,
              nfcTag.id!,
              'rfid',
              Theme.of(context)
                  .copyWith(colorScheme: widget.theme!.colorScheme));
        });
      } else {
        setState(() {
          _nfcData = "No NFC tag found";
        });
      }
    } catch (e) {
      setState(() {
        _nfcData = "Error: $e";
      });
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_nfcData),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
