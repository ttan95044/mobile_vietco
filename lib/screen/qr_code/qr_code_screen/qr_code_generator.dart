import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeGenerator extends StatelessWidget {
  QrCodeGenerator({super.key, required this.website});
  final String website;
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> captureAndSaveImage() async {
    final Uint8List? uint8list = await screenshotController.capture();
    if (uint8list != null) {
      final PermissionStatus status = await Permission.storage.request();
      if (status.isDenied) {
        final result = await ImageGallerySaver.saveImage(uint8list);
        if (result['isSuccess']) {
          print('Image saved Gallery');
        }
      } else {
        print('Failed to save ${required}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR code generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Screenshot(
            //   controller: null,
            //   child: QrImageView(
            //     data: website,
            //     version: QrVersions.auto,
            //     gapless: false,
            //     size: 320,
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            const Text('Scan this QR code'),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Capture and save as image"),
            ),
          ],
        ),
      ),
    );
  }
}
