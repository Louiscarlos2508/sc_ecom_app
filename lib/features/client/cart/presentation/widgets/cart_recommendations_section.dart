import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/models/product.dart';
import 'package:economax/shared/core/widgets/fcfa_price.dart';
import 'package:economax/shared/features/product/presentation/providers/product_provider.dart';
import 'package:economax/shared/features/product/presentation/screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';
import 'recommendation_card.dart';

/// Section de recommandations pour le panier
class CartRecommendationsSection extends ConsumerWidget {
  const CartRecommendationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(publicProductsProvider);
    final cart = ref.watch(cartProvider);
    final cartProductIds = cart.keys.toSet();

    // Filtrer pour exclure les produits déjà dans le panier
    final recommendations = allProducts
        .where((product) => !cartProductIds.contains(product.id))
        .take(10)
        .toList();

    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.favorite_border,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Vous aimerez aussi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 255,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final product = recommendations[index];
              return SizedBox(
                width: 180,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: RecommendationCard(product: product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

