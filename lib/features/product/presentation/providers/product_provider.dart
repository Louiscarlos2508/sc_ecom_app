import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/data/mock_data.dart';

/// Notifier pour les produits
class ProductNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() => MockData.demoProducts;

  /// Obtenir uniquement les produits publics (non trade-only)
  List<Product> getPublicProducts() {
    return state.where((p) => !p.isTradeOnly).toList();
  }

  /// Obtenir les produits de troc d'un utilisateur
  List<Product> getUserTradeProducts(String userId) {
    return state.where((p) => p.isTradeOnly && p.sellerId == userId).toList();
  }

  /// Ajouter un nouveau produit
  void addProduct(Product product) {
    state = [...state, product];
  }

  /// Mettre à jour un produit
  void updateProduct(Product product) {
    state = state.map((p) => p.id == product.id ? product : p).toList();
  }

  /// Supprimer un produit
  void removeProduct(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  /// Rechercher des produits
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return state;
    final lowerQuery = query.toLowerCase();
    return state.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filtrer par catégorie (simplifié)
  List<Product> filterByCategory(String category) {
    if (category.isEmpty || category == 'Tout') return state;
    // TODO: Implémenter un vrai système de catégories
    return state;
  }
}

/// Provider pour les produits
final productProvider = NotifierProvider<ProductNotifier, List<Product>>(
  () => ProductNotifier(),
);

/// Provider pour un produit spécifique
final productByIdProvider = Provider.family<Product?, String>(
  (ref, productId) {
    final products = ref.watch(productProvider);
    try {
      return products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  },
);

/// Provider pour les produits publics uniquement (exclut les produits de troc)
final publicProductsProvider = Provider<List<Product>>(
  (ref) {
    final products = ref.watch(productProvider);
    return products.where((p) => !p.isTradeOnly).toList();
  },
);

/// Provider pour les produits de troc d'un utilisateur
final userTradeProductsProvider = Provider.family<List<Product>, String>(
  (ref, userId) {
    final products = ref.watch(productProvider);
    return products.where((p) => p.isTradeOnly && p.sellerId == userId).toList();
  },
);

/// Provider pour la recherche de produits (uniquement publics)
final productSearchProvider = Provider.family<List<Product>, String>(
  (ref, query) {
    final products = ref.watch(publicProductsProvider);
    if (query.isEmpty) return products;
    final lowerQuery = query.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery);
    }).toList();
  },
);

