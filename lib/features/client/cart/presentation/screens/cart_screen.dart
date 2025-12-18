import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/models/product.dart';
import 'package:economax/shared/core/models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import '../widgets/empty_cart_widget.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_checkout_bar.dart';
import '../widgets/cart_recommendations_section.dart';
import '../widgets/security_section.dart';

/// Écran du panier (inspiré AliExpress)
/// Avec calcul automatique des frais de livraison
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProducts = ref.watch(cartProductsProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final user = ref.watch(currentUserProvider);
    
    // Séparer les produits disponibles et indisponibles
    final availableItems = cartProducts.where((item) {
      // Pour l'instant, tous les produits sont disponibles
      return true;
    }).toList();
    
    final unavailableItems = <({Product product, CartItem item})>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text('Panier (${cartProducts.length})'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: availableItems.isEmpty && unavailableItems.isEmpty
                ? const EmptyCartWidget()
                : CustomScrollView(
                    slivers: [
                      // Items disponibles
                      if (availableItems.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = availableItems[index];
                                return CartItemCard(
                                  product: item.product,
                                  cartItem: item.item,
                                );
                              },
                              childCount: availableItems.length,
                            ),
                          ),
                        ),
                      // Section Sécurité
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: SecuritySection(),
                        ),
                      ),
                      // Section Recommandations
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CartRecommendationsSection(),
                        ),
                      ),
                    ],
                  ),
          ),
          // Barre de checkout en bas
          if (availableItems.isNotEmpty)
            CartCheckoutBar(itemCount: availableItems.length),
        ],
      ),
    );
  }
}
