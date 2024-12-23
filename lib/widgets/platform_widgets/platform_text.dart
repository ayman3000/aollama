import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// General-purpose PlatformText widget for rendering text
/// with platform-specific styles
class PlatformText extends PlatformWidget {
  final String text;
  final TextStyle? materialStyle;
  final TextStyle? cupertinoStyle;
  final TextAlign? textAlign;
  final Map<String,dynamic>? style;

  const PlatformText( {
    super.key,
    required this.text,
    this.materialStyle,
    this.cupertinoStyle,
    this.textAlign,
    this.style
  });

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    TextStyle inferredStyle = TextStyle(fontSize: style?['fontSize'] ?? 16);
    return Text(
      text,
      style: cupertinoStyle ?? const TextStyle(fontSize: 18.0, color: CupertinoColors.white),
      textAlign: textAlign,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return Text(
      text,
      style: materialStyle ?? const TextStyle(fontSize: 18.0, color: Colors.white),
      textAlign: textAlign,
    );
  }
}
