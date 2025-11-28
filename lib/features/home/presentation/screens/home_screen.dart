import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/product_card.dart';
import '../../../product/presentation/screens/product_detail_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../providers/navigation_provider.dart';

/// Écran d'accueil ECONOMAX (inspiré interface moderne e-commerce)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Product> products = MockData.demoProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un produit...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      // TODO: Recherche par image
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Catégories horizontales
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CategoryChip(label: 'Explore', isSelected: false),
                  const SizedBox(width: 8),
                  _CategoryChip(label: 'PROMOTIONS', isSelected: true),
                  const SizedBox(width: 8),
                  _CategoryChip(label: 'Femmes'),
                  const SizedBox(width: 8),
                  _CategoryChip(label: 'Électronique'),
                ],
              ),
            ),
          ),
          // Produits en scroll horizontal (avec quantités minimales)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.take(3).length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return SizedBox(
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _HorizontalProductCard(
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
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Section "More to love"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'More to love',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          // Grille de produits (2 colonnes) avec badges et stats
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return _GridProductCard(
                    product: product,
                    index: index,
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
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip de catégorie
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    this.isSelected = false,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Filtrer par catégorie
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.onPrimary
                : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Carte produit horizontale (pour scroll horizontal)
class _HorizontalProductCard extends StatelessWidget {
  const _HorizontalProductCard({
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 8),
          // Prix et quantité minimale
          Text(
            'XOF${product.priceInFcfa.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )} each',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '≥3 pcs',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

/// Carte produit en grille
class _GridProductCard extends StatelessWidget {
  const _GridProductCard({
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
          // Image avec badges
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
                // Badges en overlay
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
                            'Choice',
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
          // Nom du produit
          Text(
            product.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Statut (added to cart ou sale)
          if (addedToCart > 20)
            Text(
              '$addedToCart added to cart',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
            )
          else if (hasPromo)
            Text(
              'Sale -$discountPercent% now',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          const SizedBox(height: 4),
          // Prix
          Row(
            children: [
              Text(
                'XOF${product.priceInFcfa.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                )}.00',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Stats (sold + rating)
          Row(
            children: [
              Text(
                '$soldCount sold',
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
