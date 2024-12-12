import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatingImageWidget extends StatefulWidget {
  final String imagePath;
  final double size;

  const RotatingImageWidget({
    required this.imagePath,
    this.size = 50.0,
    Key? key,
  }) : super(key: key);

  @override
  _RotatingImageWidgetState createState() => _RotatingImageWidgetState();
}

class _RotatingImageWidgetState extends State<RotatingImageWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Makes the animation loop indefinitely
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 3 * math.pi, // Rotate 360 degrees
          child: Image.asset(
            widget.imagePath,
            width: widget.size,
            height: widget.size,
          ),
        );
      },
    );
  }
}
