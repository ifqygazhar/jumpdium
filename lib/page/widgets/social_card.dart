import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';

class SocialCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  const SocialCardWidget({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: hintColor.withValues(alpha: 0.6)),
      ),
    );
  }
}
