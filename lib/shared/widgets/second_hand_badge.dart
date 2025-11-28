import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge "Seconde main" → fond #FF9800 + texte "D'occasion"
class SecondHandBadge extends StatelessWidget {
  const SecondHandBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        "D'occasion",
        style: TextStyle(
          color: AppColors.onPrimary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

