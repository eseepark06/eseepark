import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            scanWindow: Rect.fromCenter(center: Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2), width: 250, height: 250),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                print("QR Code Scanned: ${barcode.rawValue}");
                controller.stop();

                if(barcode.rawValue != null) {
                  final json = jsonDecode(barcode.rawValue.toString());

                  Navigator.pop(context, json);

                  return;
                } else {
                  Navigator.pop(context, null);

                }
              }
            },
          ),

          // Custom QR Border Overlay
          Center(
            child: CustomPaint(
              painter: QrBorderPainter(),
              child: SizedBox(
                width: 250,
                height: 250,
              ),
            ),
          ),

          // Instruction text
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Align the QR code within the frame",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom QR Border Painter
class QrBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double cornerLength = 30;

    // Draw corners
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint); // Top Left - Horizontal
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint); // Top Left - Vertical

    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint); // Top Right - Horizontal
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint); // Top Right - Vertical

    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint); // Bottom Left - Horizontal
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint); // Bottom Left - Vertical

    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint); // Bottom Right - Horizontal
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint); // Bottom Right - Vertical
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
