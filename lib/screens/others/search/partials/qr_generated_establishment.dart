  import 'package:eseepark/globals.dart';
  import 'package:eseepark/models/establishment_model.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:qr_flutter/qr_flutter.dart';

  class QRGeneratedEstablishment extends StatefulWidget {
    final String qrData;
    final Establishment establishment;

    const QRGeneratedEstablishment({
      super.key,
      required this.qrData,
      required this.establishment
    });

    @override
    State<QRGeneratedEstablishment> createState() => _QRGeneratedEstablishmentState();
  }

  class _QRGeneratedEstablishmentState extends State<QRGeneratedEstablishment> {
    @override
    Widget build(BuildContext context) {
      return Container(
        height: screenHeight * 0.83,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.07
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                Text('Scan QR code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08
                  ),
                ),
                Text('Scan this QR to be redirected to ${widget.establishment.name} establishment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: screenWidth * 0.035
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(6)
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
                Text('You may share this generated QR to your friends!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: screenWidth * 0.035
                  ),
                ),

              ],
            ),
            Container(
              width: screenWidth,
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.05
              ),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.016
                  )
                ),
                child: Text('Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.04
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
