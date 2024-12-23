import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTextField extends PlatformWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextStyle? style;
  final InputDecoration? decoration;
  final TextStyle? cupertinoStyle;
  final TextStyle? cupertinoHintStyle;
  final Color? fillColor;
  final int? maxLines;

  PlatformTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.style,
    this.decoration,
    this.cupertinoStyle,
    this.cupertinoHintStyle,
    this.fillColor,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: cupertinoStyle ?? style ?? CupertinoTheme.of(context).textTheme.textStyle,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: fillColor ?? CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),

      ),
      placeholderStyle: cupertinoHintStyle ?? const TextStyle(color: CupertinoColors.inactiveGray),


    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration ??
          InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: fillColor ?? Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
    );
  }
}
