import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:economax/shared/core/models/product.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/features/product/presentation/screens/product_detail_screen.dart';
import 'package:economax/shared/features/product/presentation/providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/grid_product_card.dart';
import '../widgets/featured_products_section.dart';
import '../widgets/notification_icon.dart';
import '../widgets/home_search_bar.dart';
import '../utils/product_filter_utils.dart';

/// Écran d'accueil ECONOMAX (inspiré interface moderne e-commerce)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey _productsGridKey = GlobalKey();

  void _scrollToProducts() {
    if (_productsGridKey.currentContext != null) {
      Scrollable.ensureVisible(
        _productsGridKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1, // Scroll pour que la grille soit visible en haut
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser uniquement les produits publics (exclure les produits de troc)
    final allProducts = ref.watch(publicProductsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = ref.watch(categoriesProvider);
    
    // Filtrer les produits par catégorie
    final products = selectedCategory == null || selectedCategory == 'Tout'
        ? allProducts
        : ProductFilterUtils.filterProductsByCategory(
            allProducts,
            selectedCategory,
          );

    // Mélanger les produits pour éviter qu'ils soient groupés par type (grossiste/simple)
    // Utiliser un seed basé sur la catégorie pour un ordre stable
    final shuffledProducts = List<Product>.from(products);
    shuffledProducts.shuffle(Random(selectedCategory.hashCode));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const HomeSearchBar(),
        actions: [
          // Icône de notifications avec badge
          const NotificationIcon(),
          const SizedBox(width: 8),
        ],
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
                children: categories.map((category) {
                  final isSelected = selectedCategory == category ||
                      (selectedCategory == null && category == 'Tout');
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: category,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).setCategory(
                              category == 'Tout' ? null : category,
                            );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Section produits en vedette (carrousel horizontal)
          if (shuffledProducts.isNotEmpty)
            SliverToBoxAdapter(
              child: FeaturedProductsSection(
                products: shuffledProducts,
                title: selectedCategory == null || selectedCategory == 'Tout'
                    ? 'Produits en vedette'
                    : selectedCategory == 'PROMOTIONS'
                        ? 'Promotions'
                        : selectedCategory == 'Nouveautés'
                            ? 'Nouveautés'
                            : 'Sélection ${selectedCategory.toLowerCase()}',
                onViewAll: shuffledProducts.length > 3 ? _scrollToProducts : null,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // Section produits (dynamique selon la catégorie)
          if (products.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  selectedCategory == null || selectedCategory == 'Tout'
                      ? 'Produits populaires'
                      : selectedCategory == 'PROMOTIONS'
                          ? 'Promotions du moment'
                          : selectedCategory == 'Nouveautés'
                              ? 'Nouveautés'
                              : 'Produits ${selectedCategory.toLowerCase()}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ),
            ),
          if (products.isNotEmpty)
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          // Grille de produits (2 colonnes) avec badges et stats
          if (products.isNotEmpty)
            SliverPadding(
              key: _productsGridKey,
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
                            return GridProductCard(
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
            )
          else
            // Message si aucun produit trouvé
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun produit trouvé',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Essayez une autre catégorie',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
