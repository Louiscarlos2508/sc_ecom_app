import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/cart_item.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/data/mock_data.dart';

/// Notifier pour le panier
class CartNotifier extends Notifier<Map<String, CartItem>> {
  @override
  Map<String, CartItem> build() => {};

  /// Ajouter un produit au panier
  void addProduct(Product product, {int quantity = 1}) {
    final currentItems = state;
    final existingItem = currentItems[product.id];

    if (existingItem != null) {
      state = {
        ...currentItems,
        product.id: existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        ),
      };
    } else {
      state = {
        ...currentItems,
        product.id: CartItem(
          productId: product.id,
          quantity: quantity,
        ),
      };
    }
  }

  /// Retirer un produit du panier
  void removeProduct(String productId) {
    final currentItems = {...state};
    currentItems.remove(productId);
    state = currentItems;
  }

  /// Mettre à jour la quantité d'un produit
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }

    final currentItems = state;
    final existingItem = currentItems[productId];
    if (existingItem != null) {
      state = {
        ...currentItems,
        productId: existingItem.copyWith(quantity: quantity),
      };
    }
  }

  /// Sélectionner/désélectionner un produit
  void toggleSelection(String productId) {
    final currentItems = state;
    final existingItem = currentItems[productId];
    if (existingItem != null) {
      state = {
        ...currentItems,
        productId: existingItem.copyWith(selected: !existingItem.selected),
      };
    }
  }

  /// Sélectionner/désélectionner tous les produits
  void toggleAllSelection(bool selected) {
    final currentItems = state;
    state = {
      for (final entry in currentItems.entries)
        entry.key: entry.value.copyWith(selected: selected),
    };
  }

  /// Vider le panier
  void clear() {
    state = {};
  }

  /// Obtenir les produits sélectionnés
  List<CartItem> getSelectedItems() {
    return state.values.where((item) => item.selected).toList();
  }

  /// Calculer le total des produits sélectionnés
  int getSelectedTotal() {
    final selectedItems = getSelectedItems();
    int total = 0;
    for (final item in selectedItems) {
      final product = _getProductById(item.productId);
      if (product != null) {
        total += product.priceInFcfa * item.quantity;
      }
    }
    return total;
  }

  /// Calculer les frais de livraison (simplifié)
  int calculateDeliveryFee(String city) {
    // Frais de livraison selon la ville
    switch (city.toLowerCase()) {
      case 'ouagadougou':
        return 1000; // 1000 FCFA
      case 'bobo-dioulasso':
      case 'bobo':
        return 1500; // 1500 FCFA
      case 'koudougou':
        return 2000; // 2000 FCFA
      default:
        return 2500; // 2500 FCFA pour autres villes
    }
  }

  Product? _getProductById(String productId) {
    try {
      return MockData.demoProducts.firstWhere(
        (p) => p.id == productId,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Provider pour le panier
final cartProvider = NotifierProvider<CartNotifier, Map<String, CartItem>>(
  () => CartNotifier(),
);

/// Provider pour obtenir les produits du panier avec leurs détails
final cartProductsProvider = Provider<List<({Product product, CartItem item})>>(
  (ref) {
    final cart = ref.watch(cartProvider);
    final products = <({Product product, CartItem item})>[];

    for (final item in cart.values) {
      try {
        final product = MockData.demoProducts.firstWhere(
          (p) => p.id == item.productId,
        );
        products.add((product: product, item: item));
      } catch (e) {
        // Produit introuvable (peut être indisponible)
      }
    }

    return products;
  },
);

/// Provider pour le total du panier
final cartTotalProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  int total = 0;
  for (final item in cart.values) {
    if (item.selected) {
      try {
        final product = MockData.demoProducts.firstWhere(
          (p) => p.id == item.productId,
        );
        total += product.priceInFcfa * item.quantity;
      } catch (e) {
        // Produit introuvable
      }
    }
  }
  return total;
});

/// Provider pour le nombre d'items dans le panier
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});

