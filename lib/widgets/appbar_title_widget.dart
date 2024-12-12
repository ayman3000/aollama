import 'package:flutter/material.dart';

class AppBarTitleWidget extends StatelessWidget {
  const AppBarTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensures the title contents are centered
      children: [
        // Logo Image
        Container(
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
        ),
        const SizedBox(width: 12), // Slightly increase spacing for balance
        // App Name
        const Text(
          "AOllama",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28, // Slightly larger font for emphasis
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
      ],
    );
  }
}
