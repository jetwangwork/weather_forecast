import 'package:flutter/material.dart';

class SuffixCloseButton extends StatelessWidget {
  const SuffixCloseButton({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return controller.text.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.clear),
            splashColor: Colors.transparent, // 取消水波效果
            highlightColor: Colors.transparent, // 取消水波效果
            onPressed: () {
              controller.clear();
            },
          )
        : const SizedBox();
  }
}