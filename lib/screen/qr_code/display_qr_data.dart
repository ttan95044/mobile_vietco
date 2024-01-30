import 'package:flutter/material.dart';

class DisplayQRDataWidget extends StatelessWidget {
  final String qrData; // Thay đổi từ Map<String, dynamic> sang String

  DisplayQRDataWidget({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Data'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin từ mã QR:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildQRDataList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQRDataList() {
    // Tạo một widget Text hiển thị dữ liệu từ mã QR
    return Text(
      qrData,
      style: TextStyle(fontSize: 16),
    );
  }
}
