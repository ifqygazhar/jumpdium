import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';

class NotFoundView extends StatelessWidget {
  final bool isDarkMode;

  const NotFoundView({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getBackgroundColor(isDarkMode),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 80),
          const SizedBox(height: 20),
          Text(
            "Oops! Article Not Found",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: getTextColor(isDarkMode),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "We couldn't find the Medium article from the link you provided.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: getTextColor(isDarkMode).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text(
              "Go Back",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
