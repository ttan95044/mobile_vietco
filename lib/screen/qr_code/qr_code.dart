import 'package:flutter/material.dart';
import 'package:mobile_vietco/screen/qr_code/qr_code_screen/qr_code_generator.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _websiteController = TextEditingController();
  }

  @override
  void dispose() {
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QrCode'),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(hintText: 'Website'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QrCodeGenerator(
                      website: _websiteController.text,
                    ),
                  ),
                );
              },
              child: const Text("Generate QR code"),
            )
          ],
        ),
      ),
    );
  }
}
