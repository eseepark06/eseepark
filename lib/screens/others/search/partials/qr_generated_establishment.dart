import 'package:eseepark/globals.dart';
import 'package:eseepark/models/establishment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QRGeneratedEstablishment extends StatefulWidget {
  final String qrData;
  final Establishment establishment;

  const QRGeneratedEstablishment({
    super.key,
    required this.qrData,
    required this.establishment,
  });

  @override
  State<QRGeneratedEstablishment> createState() => _QRGeneratedEstablishmentState();
}

class _QRGeneratedEstablishmentState extends State<QRGeneratedEstablishment> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isSharing = false; // Track sharing state

  /// Function to capture the full widget and share as an image
  Future<void> _shareFullScreen() async {
    setState(() => _isSharing = true); // Disable button

    try {
      await Future.delayed(Duration(milliseconds: 200)); // Ensure rendering is done

      RenderRepaintBoundary? boundary =
      _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        print('Error: Render boundary is null');
        setState(() => _isSharing = false);
        return;
      }

      if (boundary.debugNeedsPaint) {
        print('Waiting for widget to finish painting...');
        await Future.delayed(Duration(milliseconds: 300));
        WidgetsBinding.instance!.addPostFrameCallback((_) => _shareFullScreen());
        return;
      }

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

      if (byteData == null) {
        print('Error: ByteData is null');
        setState(() => _isSharing = false);
        return;
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_full_view.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Scan this QR to visit ${widget.establishment.name}!',
        subject: '${widget.establishment.name} QR Code',
      );
    } catch (e) {
      print('Error sharing QR Code: $e');
    } finally {
      setState(() => _isSharing = false); // Enable button after sharing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.83,
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Scan QR code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
                Text(
                  'Scan this QR to be redirected to ${widget.establishment.name} establishment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                SizedBox(height: screenHeight * 0.03),

                /// QR Code Container
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: QrImageView(
                    data: widget.qrData,
                    size: screenWidth * 0.5,
                    version: QrVersions.auto,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    embeddedImage: AssetImage('assets/images/general/eseepark-white-bg-1.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(screenWidth * 0.12, screenWidth * 0.12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),
                Text(
                  'You may share this generated QR with your friends!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                SizedBox(height: screenHeight * 0.02),

                /// Share Button (Disabled when sharing)
                ElevatedButton.icon(
                  onPressed: _isSharing ? null : _shareFullScreen,
                  icon: _isSharing
                      ? SizedBox(
                    width: screenWidth * 0.04,
                    height: screenWidth * 0.04,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Icon(
                    Icons.share,
                    color: Theme.of(context).colorScheme.primary,
                    size: screenWidth * 0.045,
                  ),
                  label: Text(
                    _isSharing ? 'Sharing...' : 'Share',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Done Button
          Container(
            width: screenWidth,
            padding: EdgeInsets.only(bottom: screenHeight * 0.05),
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
