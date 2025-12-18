import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/models/product.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/widgets/second_hand_badge.dart';
import 'package:economax/shared/core/widgets/verified_wholesaler_badge.dart';
import 'package:economax/shared/core/widgets/reported_badge.dart';
import 'package:economax/shared/core/widgets/product_image_gallery.dart';
import '../providers/product_provider.dart';
import '../widgets/product_price_section.dart';
import '../widgets/product_seller_info.dart';
import '../widgets/product_comments_section.dart';
import '../widgets/product_action_buttons.dart';
import 'package:economax/features/client/history/presentation/providers/history_provider.dart';
import 'package:economax/features/client/favorite/presentation/providers/favorite_provider.dart';

/// Écran de détail d'un produit amélioré (côté client)
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productByIdProvider(productId));
    
    // Ajouter à l'historique quand le produit est chargé
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (product != null) {
        ref.read(historyProvider.notifier).addToHistory(product.id);
      }
    });

    if (product == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          title: const Text('Produit introuvable'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Ce produit n\'existe pas ou a été supprimé',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final isFavorite = ref.watch(favoriteProvider).contains(product.id);
              final favoriteNotifier = ref.read(favoriteProvider.notifier);
              
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                onPressed: () {
                  favoriteNotifier.toggleFavorite(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Retiré des favoris'
                            : 'Ajouté aux favoris',
                      ),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Galerie d'images
          SliverToBoxAdapter(
            child: ProductImageGallery(imageUrls: product.imageUrls),
          ),
          // Contenu principal
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Badges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (product.isSecondHand) const SecondHandBadge(),
                    if (product.isVerifiedWholesaler)
                      const VerifiedWholesalerBadge(),
                    if (product.isReported && product.reportReason != null)
                      ReportedBadge(reason: product.reportReason!),
                  ],
                ),
                const SizedBox(height: 20),
                // Nom du produit
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 12),
                // Prix (avec options grossiste amélioré)
                ProductPriceSection(product: product),
                const SizedBox(height: 24),
                  // Troc disponible
                  if (product.isTradable) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.swap_horiz,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Troc disponible',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          if (product.tradeDescription != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              product.tradeDescription!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                // Informations vendeur améliorées
                ProductSellerInfo(product: product),
                const SizedBox(height: 24),
                // Section Commentaires améliorée
                ProductCommentsSection(productId: product.id),
                const SizedBox(height: 32),
                // Boutons d'action améliorés
                ProductActionButtons(product: product),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
