import 'package:flutter/material.dart';
import 'package:mobile_vietco/screen/qr_code/display_qr_data.dart';
import 'package:mobile_vietco/screen/qr_code/qr_scanner_overlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerWidget extends StatefulWidget {
  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Positioned(
            top: 20.0,
            left: 20.0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: IconButton(
              icon: Icon(
                Icons.image,
                color: Colors.white,
              ),
              onPressed: () {
                // Xử lý sự kiện khi người dùng bấm nút upload ảnh
              },
            ),
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Phân tích dữ liệu quét được từ mã QR
      String? qrData = scanData.code;

      if (qrData != null && qrData.isNotEmpty) {
        // Tắt camera trước khi chuyển hướng màn hình
        controller.pauseCamera();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayQRDataWidget(qrData: qrData),
          ),
        ).then((_) {
          // Sau khi quay trở lại từ màn hình hiển thị dữ liệu, tiếp tục camera
          controller.resumeCamera();
        });
      } else {
        print('Dữ liệu từ mã QR không hợp lệ');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
