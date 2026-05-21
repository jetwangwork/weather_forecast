import 'package:weather_forecast/widgets/edit_text_bar/suffix_close_button.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.controller,
    this.hintText
  });

  final EdgeInsetsGeometry padding;
  final TextEditingController controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: SuffixCloseButton(controller: controller),
        ),
      ),
    );
  }
}