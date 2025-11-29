import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/utils/price_formatter.dart';
import '../../../product/presentation/providers/product_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/trade_provider.dart';
import '../widgets/target_product_card.dart';
import '../widgets/product_selection_list.dart';
import '../widgets/trade_message_input.dart';
import '../widgets/trade_submit_button.dart';
import '../widgets/custom_product_upload.dart';
import '../widgets/trade_mode_selector.dart';
import '../widgets/custom_product_preview.dart';

/// Écran pour proposer un troc
class TradeProposalScreen extends ConsumerStatefulWidget {
  const TradeProposalScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  ConsumerState<TradeProposalScreen> createState() =>
      _TradeProposalScreenState();
}

class _TradeProposalScreenState extends ConsumerState<TradeProposalScreen> {
  Product? _selectedProduct;
  final _messageController = TextEditingController();
  bool _useCustomProduct = false;
  
  // Données du produit personnalisé
  String? _customProductName;
  String? _customProductDescription;
  int? _customProductPrice;
  List<String>? _customProductImageUrls;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetProduct = ref.watch(productByIdProvider(widget.productId));
    final user = ref.watch(currentUserProvider);
    // Utiliser uniquement les produits de troc de l'utilisateur
    final myTradeProducts = user != null
        ? ref.watch(userTradeProductsProvider(user.id))
        : <Product>[];

    if (targetProduct == null) {
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
                'Ce produit n\'existe pas',
                style: Theme.of(context).textTheme.titleLarge,
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

    // Produits que l'utilisateur peut proposer en troc
    // Ce sont les produits qu'il a déjà téléversés précédemment (pour des trocs qui n'ont pas abouti)
    // On filtre pour exclure le produit cible
    final myProducts = myTradeProducts
        .where((p) => p.sellerId != targetProduct.sellerId)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Proposer un troc'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Produit cible
            TargetProductCard(product: targetProduct),
            const SizedBox(height: 32),
            // Choix du mode : sélectionner ou téléverser
            TradeModeSelector(
              useCustomProduct: _useCustomProduct,
              onModeChanged: (useCustom) {
                setState(() {
                  _useCustomProduct = useCustom;
                  if (useCustom) {
                    _selectedProduct = null;
                  } else {
                    _customProductName = null;
                    _customProductDescription = null;
                    _customProductPrice = null;
                    _customProductImageUrls = null;
                  }
                });
              },
            ),
            const SizedBox(height: 24),
            // Contenu selon le mode choisi
            if (!_useCustomProduct)
              ProductSelectionList(
                products: myProducts,
                selectedProduct: _selectedProduct,
                onProductSelected: (product) {
                  setState(() {
                    _selectedProduct = product;
                  });
                },
              )
            else
              CustomProductUpload(
                onProductCreated: ({
                  required String name,
                  required String description,
                  required int estimatedPrice,
                  required images,
                }) {
                  setState(() {
                    _customProductName = name;
                    _customProductDescription = description;
                    _customProductPrice = estimatedPrice;
                    // TODO: Uploader les images et obtenir les URLs
                    // Pour l'instant, on simule avec des URLs temporaires
                    _customProductImageUrls = List.generate(
                      images.length,
                      (index) => 'https://picsum.photos/300/300?random=${DateTime.now().millisecondsSinceEpoch + index}',
                    );
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Produit créé ! Vous pouvez maintenant envoyer la proposition.',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            // Aperçu du produit personnalisé si créé
            if (_useCustomProduct &&
                _customProductName != null &&
                _customProductImageUrls != null &&
                _customProductImageUrls!.isNotEmpty &&
                _customProductPrice != null) ...[
              const SizedBox(height: 24),
              CustomProductPreview(
                productName: _customProductName!,
                productPrice: _customProductPrice!,
                imageUrl: _customProductImageUrls!.first,
              ),
            ],
            const SizedBox(height: 24),
            // Message
            TradeMessageInput(controller: _messageController),
            const SizedBox(height: 32),
            // Bouton envoyer
            TradeSubmitButton(
              isEnabled: (!_useCustomProduct && _selectedProduct != null) ||
                  (_useCustomProduct &&
                      _customProductName != null &&
                      _customProductImageUrls != null &&
                      _customProductImageUrls!.isNotEmpty),
              onSubmit: () {
                final currentUser = ref.read(currentUserProvider);
                if (currentUser == null) return;

                try {
                  if (!_useCustomProduct) {
                    // Mode sélection : utiliser un produit existant
                    if (_selectedProduct == null) return;
                    ref.read(tradeProvider.notifier).createTrade(
                          targetProductId: widget.productId,
                          offeredProductId: _selectedProduct!.id,
                          proposerId: currentUser.id,
                          message: _messageController.text.isEmpty
                              ? null
                              : _messageController.text,
                        );
                  } else {
                    // Mode téléversement : créer un produit temporaire
                    if (_customProductName == null ||
                        _customProductImageUrls == null ||
                        _customProductImageUrls!.isEmpty) return;

                    // Créer un produit pour le troc (isTradeOnly = true pour qu'il ne soit pas visible dans la plateforme)
                    final tradeProduct = Product(
                      id: 'trade_${DateTime.now().millisecondsSinceEpoch}',
                      name: _customProductName!,
                      description: _customProductDescription ?? '',
                      priceInFcfa: _customProductPrice ?? 0,
                      imageUrl: _customProductImageUrls!.first,
                      imageUrls: _customProductImageUrls!,
                      sellerId: currentUser.id,
                      sellerName: currentUser.name,
                      city: currentUser.city,
                      isTradeOnly: true, // Marquer comme produit de troc uniquement
                    );

                    // Ajouter le produit de troc (privé, non visible dans la plateforme)
                    ref.read(productProvider.notifier).addProduct(tradeProduct);

                    // Créer le troc
                    ref.read(tradeProvider.notifier).createTrade(
                          targetProductId: widget.productId,
                          offeredProductId: tradeProduct.id,
                          proposerId: currentUser.id,
                          message: _messageController.text.isEmpty
                              ? null
                              : _messageController.text,
                        );
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Proposition de troc envoyée avec succès !',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

