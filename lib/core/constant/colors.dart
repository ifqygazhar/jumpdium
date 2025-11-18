import 'package:flutter/material.dart';

// Dark Mode Colors
const Color darkBackgroundColor = Color(0xFF1C1C1E);
const Color darkSurfaceColor = Color(0xFF2C2C2E);
const Color darkTextColor = Colors.white;

// Light Mode Colors
const Color lightBackgroundColor = Color(0xFFF5F5F5);
const Color lightSurfaceColor = Colors.white;
const Color lightTextColor = Color(0xFF1C1C1E);

// Shared Colors
const Color primaryColor = Colors.orangeAccent;
const Color hintColor = Colors.grey;

// Helper Functions
Color getBackgroundColor(bool isDarkMode) {
  return isDarkMode ? darkBackgroundColor : lightBackgroundColor;
}

Color getSurfaceColor(bool isDarkMode) {
  return isDarkMode ? darkSurfaceColor : lightSurfaceColor;
}

Color getTextColor(bool isDarkMode) {
  return isDarkMode ? darkTextColor : lightTextColor;
}

Color getProgressBackgroundColor(bool isDarkMode) {
  return isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
}
