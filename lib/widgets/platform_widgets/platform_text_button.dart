import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTextButton extends PlatformWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Color? foregroundColor;
  final TextStyle? materialStyle;
  final TextStyle? cupertinoStyle;

  PlatformTextButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.alignment,
    this.foregroundColor,
    this.materialStyle,
    this.cupertinoStyle,
  }) : super(key: key);

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        alignment: alignment ?? Alignment.center,
        color: CupertinoColors.activeBlue.withOpacity(0.05), // Slight background tint
        child: DefaultTextStyle(
          style: cupertinoStyle ??
              TextStyle(
                color: foregroundColor ?? CupertinoColors.activeBlue,
                // backgroundColor: Colors.grey,
                fontSize: 20,
              ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        foregroundColor: foregroundColor ?? Colors.blue,
      ),
      onPressed: onPressed,
      child: Align(
        alignment: alignment ?? Alignment.center,
        child: DefaultTextStyle(
          style: materialStyle ?? const TextStyle(color: Colors.white, fontSize: 20),
          child: child,
        ),
      ),
    );
  }
}
