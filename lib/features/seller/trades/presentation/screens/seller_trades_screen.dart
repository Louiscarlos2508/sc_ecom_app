import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/core/models/trade.dart';
import '../../../../../shared/core/models/product.dart';
import '../../../../../shared/core/theme/app_colors.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/features/product/presentation/providers/product_provider.dart';
import 'package:economax/shared/features/troc/presentation/providers/trade_provider.dart';
import 'package:economax/shared/features/troc/presentation/widgets/trade_card.dart';
import 'package:economax/shared/features/troc/presentation/widgets/empty_trades_widget.dart';

/// Écran pour que les vendeurs gèrent les propositions de troc reçues
class SellerTradesScreen extends ConsumerWidget {
  const SellerTradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null || !user.isSeller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          title: const Text('Propositions de troc'),
        ),
        body: const Center(child: Text('Accès réservé aux vendeurs')),
      );
    }

    final allTrades = ref.watch(tradeProvider);
    final receivedTrades = allTrades
        .where((trade) => trade.sellerId == user.id)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final allProducts = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Propositions de troc reçues'),
        elevation: 0,
      ),
      body: receivedTrades.isEmpty
          ? const EmptyReceivedTradesWidget()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: receivedTrades.length,
              itemBuilder: (context, index) {
                final trade = receivedTrades[index];
                final myProduct = allProducts.firstWhere(
                  (p) => p.id == trade.productId,
                  orElse: () => allProducts.first,
                );
                final offeredProduct = allProducts.firstWhere(
                  (p) => p.id == trade.buyerProductId,
                  orElse: () => allProducts.first,
                );

                return TradeCard(
                  trade: trade,
                  targetProduct: myProduct,
                  offeredProduct: offeredProduct,
                  showActions: true,
                  onAccept: () {
                    ref.read(tradeProvider.notifier).acceptTrade(trade.id);
                    if (context.mounted) {
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
                                  'Proposition acceptée !',
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
                    }
                  },
                  onReject: () {
                    _showRejectDialog(context, ref, trade.id);
                  },
                );
              },
            ),
    );
  }
}

  void _showRejectDialog(BuildContext context, WidgetRef ref, String tradeId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Refuser la proposition'),
        content: const Text(
          'Êtes-vous sûr de vouloir refuser cette proposition de troc ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tradeProvider.notifier).rejectTrade(tradeId);
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Proposition refusée'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Refuser'),
          ),
        ],
      ),
    );
  }

