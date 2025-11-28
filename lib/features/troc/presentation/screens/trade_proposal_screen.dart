import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/product.dart';
import '../../../product/presentation/screens/product_detail_screen.dart';

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
  Product? _targetProduct;
  Product? _selectedProduct;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _loadProduct() {
    try {
      _targetProduct = MockData.demoProducts.firstWhere(
        (p) => p.id == widget.productId,
      );
    } catch (e) {
      // Produit non trouvé
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_targetProduct == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
        body: const Center(child: Text('Produit introuvable')),
      );
    }

    // Produits que l'utilisateur peut proposer en troc
    final myProducts = MockData.demoProducts
        .where((p) => p.sellerId != _targetProduct!.sellerId)
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Proposer un troc'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Produit cible
            Text(
              'Produit souhaité',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Image.network(
                  _targetProduct!.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
                title: Text(_targetProduct!.name),
                subtitle: Text('${_targetProduct!.priceInFcfa} FCFA'),
              ),
            ),
            const SizedBox(height: 32),
            // Sélection produit à proposer
            Text(
              'Votre produit à proposer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (myProducts.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun produit disponible pour le troc',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...myProducts.map((product) {
                final isSelected = _selectedProduct?.id == product.id;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.surface,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedProduct = product;
                      });
                    },
                    child: ListTile(
                      leading: Image.network(
                        product.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      ),
                      title: Text(product.name),
                      subtitle: Text('${product.priceInFcfa} FCFA'),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),
            // Message
            Text(
              'Message (optionnel)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Expliquez pourquoi vous voulez faire ce troc...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Bouton envoyer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedProduct == null
                    ? null
                    : () {
                        // TODO: Envoyer la proposition de troc
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Proposition de troc envoyée !'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Envoyer la proposition',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

