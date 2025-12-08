import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';
import '../../../product/presentation/providers/product_provider.dart';

/// Notifier pour l'historique de navigation
class HistoryNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    // Initialiser avec une liste vide
    return <String>[];
  }

  /// Ajouter un produit à l'historique
  void addToHistory(String productId) {
    final currentHistory = [...state];
    
    // Retirer le produit s'il existe déjà (pour éviter les doublons)
    currentHistory.remove(productId);
    
    // Ajouter au début
    currentHistory.insert(0, productId);
    
    // Limiter à 50 produits maximum
    if (currentHistory.length > 50) {
      currentHistory.removeRange(50, currentHistory.length);
    }
    
    state = currentHistory;
  }

  /// Vider l'historique
  void clearHistory() {
    state = [];
  }

  /// Obtenir la liste des IDs de produits dans l'historique
  List<String> get historyIds => state;
}

/// Provider pour l'historique
final historyProvider = NotifierProvider<HistoryNotifier, List<String>>(
  () => HistoryNotifier(),
);

/// Provider pour les produits de l'historique
final historyProductsProvider = Provider<List<Product>>((ref) {
  final historyIds = ref.watch(historyProvider);
  final products = ref.watch(productProvider);
  
  // Retourner les produits dans l'ordre de l'historique
  final productMap = {for (var p in products) p.id: p};
  return historyIds
      .map((id) => productMap[id])
      .where((product) => product != null)
      .cast<Product>()
      .toList();
});

