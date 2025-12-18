import 'package:flutter/material.dart';
import 'package:economax/shared/core/models/product.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/utils/price_formatter.dart';

/// Carte produit en grille
class GridProductCard extends StatelessWidget {
  const GridProductCard({
    super.key,
    required this.product,
    required this.index,
    required this.onTap,
  });

  final Product product;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Générer des stats aléatoires pour la démo
    final soldCount = (product.priceInFcfa % 100) + 10;
    final rating = 4.0 + (product.priceInFcfa % 10) / 10;
    final addedToCart = (product.priceInFcfa % 50) + 5;
    final hasPromo = index % 2 == 0;
    final discountPercent = hasPromo ? (product.priceInFcfa % 50) + 20 : 0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.secondary,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Wrap(
                    spacing: 4,
                    direction: Axis.vertical,
                    children: [
                      if (product.isVerifiedWholesaler)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Grossiste',
                            style: TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (hasPromo)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PROMOTIONS',
                            style: TextStyle(
                              color: AppColors.onPrimary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (addedToCart > 20)
            Text(
              '$addedToCart ajoutés au panier',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
            )
          else if (hasPromo)
            Text(
              'Promotion -$discountPercent% maintenant',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                PriceFormatter.format(product.priceInFcfa),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          if (product.isVerifiedWholesaler && product.minimumQuantity > 1) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.warning),
              ),
              child: Text(
                'Min. ${product.minimumQuantity} unités',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.warning,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '$soldCount vendus',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.star,
                size: 12,
                color: AppColors.warning,
              ),
              const SizedBox(width: 2),
              Text(
                rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

