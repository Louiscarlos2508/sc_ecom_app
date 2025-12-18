import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/features/product/presentation/providers/product_provider.dart';
import 'package:economax/shared/features/product/presentation/screens/product_detail_screen.dart';
import 'search_category_chip.dart';
import 'trending_product_card.dart';

/// Suggestions de recherche améliorées
class SearchSuggestions extends ConsumerWidget {
  const SearchSuggestions({
    super.key,
    required this.recentSearches,
    required this.onSearchTap,
  });

  final List<String> recentSearches;
  final ValueChanged<String> onSearchTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recherches récentes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Effacer l'historique
                  },
                  child: Text(
                    'Effacer',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return ActionChip(
                  label: Text(search),
                  onPressed: () => onSearchTap(search),
                  backgroundColor: AppColors.surface,
                  side: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
                  avatar: Icon(
                    Icons.history,
                    size: 18,
                    color: AppColors.primary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
          Text(
            'Catégories populaires',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              SearchCategoryChip(
                icon: Icons.phone_android,
                label: 'Téléphones',
                onTap: () => onSearchTap('Téléphone'),
              ),
              SearchCategoryChip(
                icon: Icons.computer,
                label: 'Électronique',
                onTap: () => onSearchTap('Électronique'),
              ),
              SearchCategoryChip(
                icon: Icons.checkroom,
                label: 'Mode',
                onTap: () => onSearchTap('Mode'),
              ),
              SearchCategoryChip(
                icon: Icons.home,
                label: 'Maison',
                onTap: () => onSearchTap('Maison'),
              ),
              SearchCategoryChip(
                icon: Icons.shopping_bag,
                label: 'Alimentaire',
                onTap: () => onSearchTap('Riz'),
              ),
              SearchCategoryChip(
                icon: Icons.directions_bike,
                label: 'Véhicules',
                onTap: () => onSearchTap('Vélo'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Produits tendance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, _) {
              final products = ref.watch(publicProductsProvider);
              final trendingProducts = products.take(4).toList();
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingProducts.length,
                  itemBuilder: (context, index) {
                    final product = trendingProducts[index];
                    return SizedBox(
                      width: 160,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: TrendingProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(
                                  productId: product.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

