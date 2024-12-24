/// This `PlatformWidget` base class was created by an original contributor.
/// It is designed to provide a base for platform-aware widgets, ensuring compatibility
/// between Material and Cupertino designs.
///
/// Credits: Andrea Bizzotto
/// Thank you for the inspiration and contribution!
//// Ref: https://github.com/bizz84/platform_aware_widgets_flutter/blob/master/lib/common_widgets/platform_widget.dart

import 'dart:io';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Base class to be extended by all platform aware widgets
abstract class PlatformWidget extends StatelessWidget {
  const PlatformWidget({super.key});

  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      // Use Cupertino on iOS
      // print("iOS");
      return buildCupertinoWidget(context);
    }
    // Use Material design on Android and other platforms
    return buildMaterialWidget(context);
  }
}