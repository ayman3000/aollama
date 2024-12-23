import 'platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformProgressIndicator extends PlatformWidget {
  final double? value; // Null for indeterminate progress
  final double? size; // Optional size for the Cupertino spinner

  const PlatformProgressIndicator({super.key, this.value, this.size});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: size ?? 10.0, // CupertinoActivityIndicator uses `radius`
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    if (value != null) {
      // Determinate progress indicator
      return CircularProgressIndicator(
        value: value,
      );
    } else {
      // Indeterminate progress indicator
      return const CircularProgressIndicator();
    }
  }
}
