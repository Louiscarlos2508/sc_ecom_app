import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/trade.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Notifier pour les propositions de troc
class TradeNotifier extends Notifier<List<Trade>> {
  @override
  List<Trade> build() {
    // Initialiser avec les données mock
    return MockData.demoTrades;
  }

  /// Créer une nouvelle proposition de troc
  void createTrade({
    required String targetProductId,
    required String offeredProductId,
    required String proposerId,
    String? message,
  }) {
    // Récupérer le vendeur du produit cible
    final targetProduct = _getProductById(targetProductId);
    if (targetProduct == null) {
      throw Exception('Produit cible introuvable');
    }

    final newTrade = Trade(
      id: 'trade_${DateTime.now().millisecondsSinceEpoch}',
      productId: targetProductId,
      sellerId: targetProduct.sellerId,
      buyerId: proposerId,
      buyerProductId: offeredProductId,
      status: TradeStatus.pending,
      createdAt: DateTime.now(),
      message: message,
    );

    state = [...state, newTrade];
  }

  /// Accepter une proposition de troc
  void acceptTrade(String tradeId) {
    state = state.map((trade) {
      if (trade.id == tradeId) {
        return Trade(
          id: trade.id,
          productId: trade.productId,
          sellerId: trade.sellerId,
          buyerId: trade.buyerId,
          buyerProductId: trade.buyerProductId,
          status: TradeStatus.accepted,
          createdAt: trade.createdAt,
          message: trade.message,
        );
      }
      return trade;
    }).toList();
  }

  /// Refuser une proposition de troc
  void rejectTrade(String tradeId) {
    state = state.map((trade) {
      if (trade.id == tradeId) {
        return Trade(
          id: trade.id,
          productId: trade.productId,
          sellerId: trade.sellerId,
          buyerId: trade.buyerId,
          buyerProductId: trade.buyerProductId,
          status: TradeStatus.rejected,
          createdAt: trade.createdAt,
          message: trade.message,
        );
      }
      return trade;
    }).toList();
  }

  /// Obtenir les propositions de troc pour un produit
  List<Trade> getTradesForProduct(String productId) {
    return state.where(
      (trade) =>
          trade.productId == productId ||
          trade.buyerProductId == productId,
    ).toList();
  }

  /// Obtenir les propositions de troc d'un utilisateur
  List<Trade> getUserTrades(String userId) {
    return state.where((trade) => trade.buyerId == userId).toList();
  }

  /// Obtenir les propositions de troc reçues par un vendeur
  List<Trade> getSellerTrades(String sellerId) {
    return state.where((trade) => trade.sellerId == sellerId).toList();
  }

  dynamic _getProductById(String productId) {
    try {
      return MockData.demoProducts.firstWhere(
        (p) => p.id == productId,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Provider pour les propositions de troc
final tradeProvider = NotifierProvider<TradeNotifier, List<Trade>>(
  () => TradeNotifier(),
);

/// Provider pour les propositions de troc d'un produit
final tradesByProductIdProvider = Provider.family<List<Trade>, String>(
  (ref, productId) {
    final trades = ref.watch(tradeProvider);
    return trades.where(
      (trade) =>
          trade.productId == productId ||
          trade.buyerProductId == productId,
    ).toList();
  },
);

