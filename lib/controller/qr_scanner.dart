import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:coffee_tracker/plugins/plant_info.dart'; // Import the file with the dialog function

class ScanQRCode extends StatefulWidget {
  final ThemeData? theme;

  const ScanQRCode({Key? key, required this.theme}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String? result;
  bool isScanning = true; // Control variable for scanning

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme!,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.theme!.colorScheme.background,
          iconTheme:
              IconThemeData(color: widget.theme!.colorScheme.onBackground),
        ),
        backgroundColor: widget.theme!.colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Qr Scan',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        widget.theme!.colorScheme.onBackground),
                              ),
                              Text(
                                'Place your QR code in the Box',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color:
                                        widget.theme!.colorScheme.onBackground),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.theme!.colorScheme.primary,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: QRCodeDartScanView(
                            scanInvertedQRCode: true, // Enable inverted QR scan
                            typeScan: TypeScan.live, // Use live scan mode
                            formats: const [
                              BarcodeFormat.qrCode
                            ], // Restrict to QR codes
                            onCapture: (Result result) {
                              if (isScanning) {
                                setState(() {
                                  this.result = result.text;
                                  isScanning = false; // Stop scanning
                                });
                                if (this.result != null &&
                                    this.result!.isNotEmpty) {
                                  // Call the static method from PlantInfo
                                  PlantInfo.showInputDialog(
                                      context,
                                      this.result!,
                                      'plantID',
                                      Theme.of(context).copyWith(
                                          colorScheme:
                                              widget.theme!.colorScheme));

                                  ///fix here the qr stop scanning when get the data
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        result ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Just place the box to QR it will automatically show the Plant Infromation',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                              color: widget.theme!.colorScheme.onBackground),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
