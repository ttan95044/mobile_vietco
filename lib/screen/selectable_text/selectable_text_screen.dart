import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectableTextScreen extends StatelessWidget {
  const SelectableTextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SelectableText & Modal Example'),
      ),
      body: Center(
        child: SelectableText(
          'Đây là một đoạn văn bản. Bạn có thể bôi đen và chọn để lưu phần văn bản này.',
          onTap: () {
            _showModal(context);
          },
          showCursor: true,
        ),
      ),
    );
  }

  void _showModal(BuildContext context) async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    String selectedText = clipboardData?.text ?? '';
    if (selectedText.isNotEmpty) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Selected Text'),
            content: Text(selectedText),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}
