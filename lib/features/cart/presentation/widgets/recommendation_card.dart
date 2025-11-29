import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/fcfa_price.dart';
import '../../../product/presentation/screens/product_detail_screen.dart';

/// Carte de recommandation améliorée
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    // Générer des stats aléatoires pour la démo (comme dans GridProductCard)
    final soldCount = (product.priceInFcfa % 100) + 10;
    final rating = 4.0 + (product.priceInFcfa % 10) / 10;
    final addedToCart = (product.priceInFcfa % 50) + 5;
    final hasPromo = (product.priceInFcfa % 2 == 0);
    final discountPercent = hasPromo ? (product.priceInFcfa % 50) + 20 : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: product.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image avec badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: AppColors.secondary,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                // Badges
                Positioned(
                  top: 8,
                  left: 8,
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 4,
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
                          child: Text(
                            'Grossiste',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onPrimary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      if (product.isSecondHand)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'D\'occasion',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                          child: Text(
                            'PROMO',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
            // Infos produit
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nom du produit
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Ville du vendeur et stats sur une ligne
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          product.city,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (addedToCart > 20 || soldCount > 10) ...[
                        Icon(
                          Icons.star,
                          size: 11,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 9,
                              ),
                        ),
                      ],
                    ],
                  ),
                  // Stats de ventes ou promo (optionnel)
                  if (soldCount > 10) ...[
                    const SizedBox(height: 3),
                    Text(
                      '$soldCount vendus',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 9,
                          ),
                    ),
                  ] else if (hasPromo) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Promo -$discountPercent%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                  const SizedBox(height: 5),
                  // Prix
                  FcfaPrice(
                    price: product.priceInFcfa,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                  ),
                  // Informations supplémentaires
                  if (product.isVerifiedWholesaler &&
                      product.minimumQuantity > 1) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Text(
                        'Min. ${product.minimumQuantity}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

