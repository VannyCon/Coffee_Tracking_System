import 'package:coffee_tracker/view/plants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

class PlantEncoded {
  static Future<void> showSuccesDialog(
    BuildContext context,
    String plantId,
    ThemeData theme,
  ) async {
    // Generate and save QR code image
    await _generateAndSaveQRCode(context, plantId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: plantId,
                      version: QrVersions.auto,
                      size: 200,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ID: $plantId',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'QR Code is Successfully Saved in Your Gallery',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onBackground),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Add logic to generate another QR code
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimary,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Add Another',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.background,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlantsPage(
                                theme: Theme.of(context)
                                    .copyWith(colorScheme: theme.colorScheme),
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> _generateAndSaveQRCode(
      BuildContext context, String plantId) async {
    try {
      final qrValidationResult = QrValidator.validate(
        data: plantId,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );

      if (qrValidationResult.status == QrValidationStatus.valid) {
        final qrCode = qrValidationResult.qrCode!;
        final painter = QrPainter.withQr(
          qr: qrCode,
          color: Colors.black,
          emptyColor: Colors.white,
          gapless: true,
        );

        final imageSize = 280.0;
        final qrSize = 200.0;
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);

        // Draw white background
        canvas.drawRect(Rect.fromLTWH(0, 0, imageSize, imageSize),
            Paint()..color = Colors.white);

        // Calculate QR code position
        final qrPosition =
            Offset((imageSize - qrSize) / 2, (imageSize - qrSize) / 2 - 20);

        // Translate canvas to QR code position and paint
        canvas.save();
        canvas.translate(qrPosition.dx, qrPosition.dy);
        painter.paint(canvas, Size(qrSize, qrSize));
        canvas.restore();

        // Add plantId text below QR code
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'ID: $plantId',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final textX = (imageSize - textPainter.width) / 2;
        final textY = qrPosition.dy + qrSize + 10;
        textPainter.paint(canvas, Offset(textX, textY));

        final picture = recorder.endRecording();
        final img = await picture.toImage(imageSize.toInt(), imageSize.toInt());
        final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

        if (pngBytes != null) {
          final buffer = pngBytes.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/qr_$plantId.png').create();
          await file.writeAsBytes(buffer);

          await GallerySaver.saveImage(file.path,
              albumName: "CoffeeTrackingSystem");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('QR Code saved to gallery as qr_$plantId.png')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving QR Code: $e')),
      );
    }
  }
}
