import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/models/trade.dart';
import 'package:economax/shared/core/models/product.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import 'package:economax/shared/features/product/presentation/providers/product_provider.dart';
import '../providers/trade_provider.dart';
import '../widgets/trade_card.dart';
import '../widgets/empty_trades_widget.dart';

/// Écran pour voir les propositions de troc du client
class ClientTradesScreen extends ConsumerWidget {
  const ClientTradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          title: const Text('Mes propositions de troc'),
        ),
        body: const Center(child: Text('Veuillez vous connecter')),
      );
    }

    final allTrades = ref.watch(tradeProvider);
    final myTrades = allTrades.where((trade) => trade.buyerId == user.id).toList();
    final allProducts = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Mes propositions de troc'),
        elevation: 0,
      ),
      body: myTrades.isEmpty
          ? const EmptyTradesWidget()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myTrades.length,
              itemBuilder: (context, index) {
                final trade = myTrades[index];
                final targetProduct = allProducts.firstWhere(
                  (p) => p.id == trade.productId,
                  orElse: () => allProducts.first,
                );
                final myProduct = allProducts.firstWhere(
                  (p) => p.id == trade.buyerProductId,
                  orElse: () => allProducts.first,
                );

                return TradeCard(
                  trade: trade,
                  targetProduct: targetProduct,
                  offeredProduct: myProduct,
                );
              },
            ),
    );
  }
}


