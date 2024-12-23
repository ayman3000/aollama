import 'package:flutter/material.dart';

class AppBarTitleWidget extends StatelessWidget {

  const AppBarTitleWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
      const double sidebarThreshold = 800;
      final bool showAll = constraints.maxWidth >= 300;
      final bool showLogoOnly = constraints.maxWidth >= 200;
      return Row(
        mainAxisSize: MainAxisSize.min, // Ensures the title contents are centered
        children: [
          // Logo Image
          showLogoOnly ? Container(
            width: 50, // Adjust the size for a balanced look
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Makes the logo circular
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Add a subtle shadow
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/logo.png', // Path to the logo image
                fit: BoxFit.cover, // Ensures the image fits properly
              ),
            ),
          ):const Text(''),
          showAll ? const SizedBox(width: 12):const Text(''), // Slightly increase spacing for balance
          // App Name

          showAll ? const Column(
            children: [
              Text(
                "AOllama Studio",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26, // Slightly larger font for emphasis
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 3,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              Text(
                "Built on Ollama Server",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12, // Slightly larger font for emphasis
                  // fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 3,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),


            ],
          ):const Text(''),
        ],
      );
        }
    );
  }
}
