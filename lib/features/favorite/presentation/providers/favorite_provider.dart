import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';
import '../../../product/presentation/providers/product_provider.dart';

/// Notifier pour les favoris
class FavoriteNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    // Initialiser avec un set vide
    return <String>{};
  }

  /// Ajouter un produit aux favoris
  void addFavorite(String productId) {
    state = {...state, productId};
  }

  /// Retirer un produit des favoris
  void removeFavorite(String productId) {
    final newState = {...state};
    newState.remove(productId);
    state = newState;
  }

  /// Toggle favori (ajouter si absent, retirer si présent)
  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      removeFavorite(productId);
    } else {
      addFavorite(productId);
    }
  }

  /// Vérifier si un produit est en favori
  bool isFavorite(String productId) {
    return state.contains(productId);
  }

  /// Obtenir la liste des IDs de produits favoris
  Set<String> get favoriteIds => state;
}

/// Provider pour les favoris
final favoriteProvider = NotifierProvider<FavoriteNotifier, Set<String>>(
  () => FavoriteNotifier(),
);

/// Provider pour les produits favoris de l'utilisateur connecté
final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final favoriteIds = ref.watch(favoriteProvider);
  final products = ref.watch(productProvider);
  
  return products.where((product) => favoriteIds.contains(product.id)).toList();
});

