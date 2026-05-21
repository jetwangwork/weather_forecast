import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  const YesNoDialog({
    super.key,
    this.hideNoButton = false,
    this.title = '',
    this.content = '',
    this.yesButtonText = '確定',
    this.noButtonText = '取消',
    this.onYesPress,
    this.onNoPress,
  });

  final bool hideNoButton;
  final String title;
  final String content;
  final String yesButtonText;
  final String noButtonText;
  final VoidCallback? onYesPress;
  final VoidCallback? onNoPress;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // 方形圓角
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(
          minHeight: title != '' ? 250 : 200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != '')
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            if (content != '')
              const SizedBox(height: 16),
            if (content != '')
              Text(
                content,
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 24),

            // Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton( // YesButton
                  onPressed: () {
                    Navigator.of(context).pop(); // 關閉 Dialog
                    onYesPress?.call();
                  },
                  child: Text(
                    yesButtonText,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

                if (!hideNoButton)
                  ElevatedButton( // NoButton
                    onPressed: () {
                      Navigator.of(context).pop(); // 關閉 Dialog
                      onNoPress?.call();
                    },
                    child: Text(
                      noButtonText,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}