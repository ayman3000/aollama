import 'package:flutter/material.dart';

/// A centralized place for your app's color constants.
class AppColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF2196F3); // Matches the blue from the logo
  static const Color secondaryBlueGrey = Color(0xFF455A64); // Blue-grey for accents

  // Background colors
  static const Color backgroundDark = Color(0xFF121212); // Matches the app's dark theme
  static const Color sidebarBackground = Color(0xFF1E1E1E); // Sidebar background color
  static const Color messageBackground = Color(0xFF1F2933); // Chat message background

  // Text colors
  static const Color textPrimary = Colors.white; // Primary text color
  static const Color textSecondary = Color(0xFFB0BEC5); // Secondary grey text

  // Button and accent colors
  static const Color buttonBlue = primaryBlue; // Button blue to match the logo
  static const Color buttonHover = Color(0xFF64B5F6); // Slightly lighter blue for hover effects

  // Message bubble colors
  static const Color userMessageBackground = Color(0xFF2C3E50); // Darker blue-grey for user messages
  static const Color botMessageBackground = Color(0xFF4A6572); // Lighter blue-grey for bot messages
  static const Color messageBorder = Color(0xFF607D8B); // Border color for message bubbles

  // Input field colors
  static const Color inputBackground = Color(0xFF263238); // Dark grey for input field
  static const Color inputBorder = Color(0xFF4F5B62); // Slightly lighter border color
  static const Color inputText = Colors.white; // White text inside the input field

  // Icon colors
  static const Color iconDefault = Colors.white; // Default icon color
  static const Color iconActive = primaryBlue; // Active icon color (matches the logo)
}
