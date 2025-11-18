import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/core/providers/theme_provider.dart';

class SocialCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  const SocialCardWidget({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider?.isDarkMode ?? true;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: getSurfaceColor(isDarkMode),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: hintColor.withValues(alpha: 0.6)),
      ),
    );
  }
}
