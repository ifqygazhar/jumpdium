import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/core/constant/static_data.dart';

class LoadingView extends StatelessWidget {
  final bool isDarkMode;
  final int randomKey;
  final double progress;

  const LoadingView({
    super.key,
    required this.isDarkMode,
    required this.randomKey,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getBackgroundColor(isDarkMode),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              loadingImgs[randomKey]!['img'] as String,
              height: 250,
              width: 250,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "\"${loadingImgs[randomKey]!['qoute']}\"",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: getTextColor(isDarkMode).withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Lagi di hek dulu nih...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: getTextColor(isDarkMode).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: getProgressBackgroundColor(isDarkMode),
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.close, color: getSurfaceColor(isDarkMode)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Stuck lebih dari 1 menit ? close",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getSurfaceColor(isDarkMode),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
