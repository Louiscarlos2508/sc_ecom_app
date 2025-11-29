import 'package:flutter/material.dart';
import '../../../../shared/models/payment_method.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/price_formatter.dart';
import 'payment_method_logo.dart';

/// En-tête pour l'écran de paiement Mobile Money
class MobileMoneyPaymentHeader extends StatelessWidget {
  const MobileMoneyPaymentHeader({
    super.key,
    required this.method,
    required this.amount,
  });

  final PaymentMethod method;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          PaymentMethodLogo(
            type: method.type,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Montant à payer',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            PriceFormatter.format(amount),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

