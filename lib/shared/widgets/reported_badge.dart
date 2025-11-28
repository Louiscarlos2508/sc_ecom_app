import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Badge "Signalé par ECONOMAX" → fond rouge drapeau #EF3340 + raison visible
class ReportedBadge extends StatelessWidget {
  const ReportedBadge({
    super.key,
    required this.reason,
  });

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning,
            size: 14,
            color: AppColors.onPrimary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'Signalé: $reason',
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

