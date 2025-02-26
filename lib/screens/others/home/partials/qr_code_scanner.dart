import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> with SingleTickerProviderStateMixin {
  MobileScannerController controller = MobileScannerController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<double> _trailPositions = [];
  bool isTorchEnabled = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 250.0,
    ).animate(_animationController);

    _animationController.addListener(() {
      _trailPositions.add(_animation.value);
      if (_trailPositions.length > 10) {
        _trailPositions.removeAt(0);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double boxSize = 250;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            scanWindow: Rect.fromCenter(
              center: Offset(screenWidth / 2, screenHeight / 2),
              width: boxSize,
              height: boxSize,
            ),
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                print("QR Code Scanned: ${barcode.rawValue}");
                controller.stop();
                _animationController.stop();


                if (barcode.rawValue != null) {
                  await Future.delayed(const Duration(milliseconds: 500));

                  final json = jsonDecode(barcode.rawValue.toString());

                  Navigator.pop(context, json);
                  return;
                } else {
                  Navigator.pop(context, null);
                }
              }
            },
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: ScannerOverlayClipper(),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Center(
            child: CustomPaint(
              painter: QrBorderPainter(),
              size: Size(boxSize, boxSize),
            ),
          ),
          Center(
            child: SizedBox(
              width: boxSize,
              height: boxSize,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      for (int i = 0; i < _trailPositions.length; i++)
                        Positioned(
                          top: _trailPositions[i],
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.red.withOpacity(0.0),
                                  Colors.red.withOpacity(0.3 * (i / _trailPositions.length)),
                                  Colors.red.withOpacity(0.6 * (i / _trailPositions.length)),
                                  Colors.red.withOpacity(0.9 * (i / _trailPositions.length)),
                                ],
                                stops: [0.0, 0.4, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: _animation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.red.withOpacity(0.0),
                                Colors.red.withOpacity(0.3),
                                Colors.red.withOpacity(0.6),
                                Colors.red.withOpacity(0.9),
                              ],
                              stops: [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
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
          Positioned(
            top: 50,
            left: screenWidth * 0.03,
            right: screenWidth * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                InkWell(
                  onTap: () {
                    controller.toggleTorch();

                    setState(() {
                      isTorchEnabled = !isTorchEnabled;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isTorchEnabled ? Colors.white : Colors.transparent
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.01),
                    child: Icon(Icons.flashlight_on_rounded,
                      color: isTorchEnabled ? Theme.of(context).colorScheme.primary : Colors.white,
                      size: screenWidth * 0.07,
                    ),
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class QrBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double cornerLength = 30;
    final double cornerRadius = 8;

    void drawCorner(double x, double y, double dx, double dy) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(Offset(x, y), Offset(dx, dy)),
          Radius.circular(cornerRadius),
        ),
        paint,
      );
    }

    drawCorner(0, 0, cornerLength, 4);
    drawCorner(0, 0, 4, cornerLength);
    drawCorner(size.width - cornerLength, 0, size.width, 4);
    drawCorner(size.width - 4, 0, size.width, cornerLength);
    drawCorner(0, size.height - 4, cornerLength, size.height);
    drawCorner(0, size.height - cornerLength, 4, size.height);
    drawCorner(size.width - cornerLength, size.height - 4, size.width, size.height);
    drawCorner(size.width - 4, size.height - cornerLength, size.width, size.height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScannerOverlayClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double boxSize = 250;
    double left = (size.width - boxSize) / 2;
    double top = (size.height - boxSize) / 2;
    double right = left + boxSize;
    double bottom = top + boxSize;

    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTRB(left, top, right, bottom), Radius.circular(30)));
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}