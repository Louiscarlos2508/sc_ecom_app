import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/utils/price_formatter.dart';
import 'package:economax/shared/core/models/coupon.dart';
import '../providers/coupon_provider.dart';

/// Écran des coupons
class CouponsScreen extends ConsumerWidget {
  const CouponsScreen({super.key});

  void _copyCodeToClipboard(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copié dans le presse-papiers'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = ref.watch(userCouponsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text('Mes coupons (${coupons.length})'),
        elevation: 0,
      ),
      body: coupons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun coupon disponible',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les coupons disponibles apparaîtront ici',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                return _CouponCard(
                  coupon: coupon,
                  onCopy: () => _copyCodeToClipboard(context, coupon.code),
                );
              },
            ),
    );
  }
}

/// Carte de coupon
class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.onCopy,
  });

  final Coupon coupon;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final discountText = coupon.discountType == DiscountType.percentage
        ? '${coupon.discountValue}%'
        : PriceFormatter.format(coupon.discountValue);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discountText,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coupon.discountType == DiscountType.percentage
                              ? 'de réduction'
                              : 'de réduction',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onPrimary.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.onPrimary,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          coupon.code,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                        ),
                        const SizedBox(height: 4),
                        TextButton.icon(
                          onPressed: onCopy,
                          icon: const Icon(
                            Icons.copy,
                            size: 16,
                            color: AppColors.onPrimary,
                          ),
                          label: const Text(
                            'Copier',
                            style: TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 12,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                coupon.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onPrimary.withOpacity(0.9),
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.onPrimary.withOpacity(0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Valide jusqu\'au ${coupon.validUntil.day}/${coupon.validUntil.month}/${coupon.validUntil.year}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.8),
                        ),
                  ),
                ],
              ),
              if (coupon.minimumPurchase != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size: 16,
                      color: AppColors.onPrimary.withOpacity(0.8),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Achat minimum: ${PriceFormatter.format(coupon.minimumPurchase!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onPrimary.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

