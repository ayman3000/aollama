import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformWidget {
  final VoidCallback onPressed;
  final String text;

  const PlatformButton({super.key, required this.onPressed, required this.text});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      color: CupertinoColors.activeBlue, // Default iOS button color
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(text),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(text),
    );
  }
}
