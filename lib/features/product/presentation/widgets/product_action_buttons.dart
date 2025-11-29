import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../payment/presentation/screens/payment_method_selection_screen.dart';
import '../../../troc/presentation/screens/trade_proposal_screen.dart';
import 'quantity_selector.dart';

/// Boutons d'action améliorés
class ProductActionButtons extends ConsumerStatefulWidget {
  const ProductActionButtons({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  ConsumerState<ProductActionButtons> createState() =>
      _ProductActionButtonsState();
}

class _ProductActionButtonsState
    extends ConsumerState<ProductActionButtons> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Initialiser la quantité minimale pour les produits en gros
    _quantity = widget.product.isVerifiedWholesaler &&
            widget.product.minimumQuantity > 1
        ? widget.product.minimumQuantity
        : 1;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isClient = user != null && !user.isSeller && !user.isAdmin;
    final minQuantity = widget.product.isVerifiedWholesaler &&
            widget.product.minimumQuantity > 1
        ? widget.product.minimumQuantity
        : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sélecteur de quantité
        Row(
          children: [
            Text(
              'Quantité:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(width: 16),
            QuantitySelector(
              quantity: _quantity,
              minQuantity: minQuantity,
              maxQuantity: 999,
              onChanged: (newQuantity) {
                setState(() {
                  _quantity = newQuantity;
                });
              },
            ),
            if (widget.product.isVerifiedWholesaler &&
                widget.product.minimumQuantity > 1)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Text(
                    'Min. ${widget.product.minimumQuantity}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        // Bouton troc
        if (widget.product.isTradable && isClient)
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TradeProposalScreen(
                    productId: widget.product.id,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Proposer un troc'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        if (widget.product.isTradable && isClient)
          const SizedBox(height: 12),
        // Bouton ajouter au panier
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(cartProvider.notifier).addProduct(
                    widget.product,
                    quantity: _quantity,
                  );
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
                          '$_quantity produit${_quantity > 1 ? 's' : ''} ajouté${_quantity > 1 ? 's' : ''} au panier',
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
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              'Ajouter au panier${_quantity > 1 ? ' ($_quantity)' : ''}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Bouton acheter maintenant
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(cartProvider.notifier).addProduct(
                    widget.product,
                    quantity: _quantity,
                  );
              // Calculer le montant total
              final totalAmount = widget.product.priceInFcfa * _quantity;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentMethodSelectionScreen(
                    totalAmount: totalAmount,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.payment),
            label: Text(
              'Acheter maintenant${_quantity > 1 ? ' ($_quantity)' : ''}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }
}

