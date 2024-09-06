import 'package:coffee_tracker/controller/manual_scan.dart';
import 'package:coffee_tracker/controller/qr_scanner.dart';
import 'package:coffee_tracker/controller/rfidscanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart'; // Import the NFC package

class ChooseScanner extends StatefulWidget {
  final ThemeData? theme;

  const ChooseScanner({Key? key, required this.theme}) : super(key: key);

  @override
  _ChooseScannerState createState() => _ChooseScannerState();
}

class _ChooseScannerState extends State<ChooseScanner> {
  bool _isNfcAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkNfcAvailability();
  }

  Future<void> _checkNfcAvailability() async {
    try {
      final nfcAvailability = await FlutterNfcKit.nfcAvailability;
      if (nfcAvailability == NFCAvailability.available) {
        setState(() {
          _isNfcAvailable = true;
        });

        // Start NFC scan if available
        await FlutterNfcKit.poll();
      } else {
        setState(() {
          _isNfcAvailable = false;
        });
      }
    } catch (e) {
      // Handle error (e.g., NFC not available or not enabled)
      setState(() {
        _isNfcAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme! ?? ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.theme!.colorScheme.background,
          title: Text(
            'Choose Scanner',
            style: TextStyle(color: widget.theme!.colorScheme.onBackground),
          ),
          iconTheme: IconThemeData(
              color:
                  widget.theme!.colorScheme.onBackground), // Set the icon color
        ),
        backgroundColor: widget.theme!.colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.theme!.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Adjust the radius here
                  ),
                ),
                onPressed: () {
                  // Handle scan action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlantManual(
                            theme: Theme.of(context).copyWith(
                                colorScheme: widget.theme!.colorScheme))),
                  );
                },
                child: Text(
                  'Manual',
                  style: TextStyle(
                      fontSize: 18,
                      color: widget.theme!.colorScheme.background),
                ),
              ),
              const SizedBox(height: 10),
              // Plants Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.theme!.colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Adjust the radius here
                  ),
                ),
                onPressed: () {
                  // Handle plants action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScanQRCode(
                            theme: Theme.of(context).copyWith(
                                colorScheme: widget.theme!.colorScheme))),
                  );
                },
                child: Text(
                  'QR Scan',
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.theme!.colorScheme.background,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // RFID Scan Button
              if (_isNfcAvailable) // Show only if NFC is available
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA5FDB3),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Adjust the radius here
                    ),
                  ),
                  onPressed: () {
                    // Handle RFID scan action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NfcReader(
                              theme: Theme.of(context).copyWith(
                                  colorScheme: widget.theme!.colorScheme))),
                    );
                  },
                  child: Text(
                    'RFID Scan',
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.theme!.colorScheme.background,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String number, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'Updated',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
