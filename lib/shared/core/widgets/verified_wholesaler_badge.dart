import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge "Grossiste vérifié" → fond vert drapeau #009E60
class VerifiedWholesalerBadge extends StatelessWidget {
  const VerifiedWholesalerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.verified,
            size: 14,
            color: AppColors.onPrimary,
          ),
          SizedBox(width: 4),
          Text(
            'Grossiste vérifié',
            style: TextStyle(
              color: AppColors.onPrimary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

