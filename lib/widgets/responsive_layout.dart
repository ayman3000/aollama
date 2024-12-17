import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget sidebar;
  final Widget content;
  final double widthThreshold;

  const ResponsiveLayout({
    Key? key,
    required this.sidebar,
    required this.content,
    this.widthThreshold = 800, // Default width threshold for showing the sidebar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if the width exceeds the threshold
        if (constraints.maxWidth >= widthThreshold) {
          // Wide screen: Show sidebar and content
          return Row(
            children: [
              SizedBox(
                width: 250, // Sidebar width
                child: sidebar,
              ),
              Expanded(child: content),
            ],
          );
        } else {
          // Narrow screen: Only show content
          return content;
        }
      },
    );
  }
}
