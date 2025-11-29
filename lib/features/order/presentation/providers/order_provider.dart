import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/cart_item.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../product/presentation/providers/product_provider.dart';

/// Notifier pour les commandes
class OrderNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    // Initialiser avec les données mock
    return MockData.demoOrders;
  }

  /// Créer une nouvelle commande depuis le panier
  Future<String> createOrderFromCart({
    required String userId,
    required String deliveryCity,
    String? deliveryAddress,
    String? notes,
    required int deliveryFee,
  }) async {
    final cart = ref.read(cartProvider);
    final selectedItems = cart.values.where((item) => item.selected).toList();

    if (selectedItems.isEmpty) {
      throw Exception('Aucun produit sélectionné dans le panier');
    }

    // Créer les items de commande
    final orderItems = <OrderItem>[];
    for (final cartItem in selectedItems) {
      final product = _getProductById(cartItem.productId);
      if (product != null) {
        orderItems.add(
          OrderItem(
            product: product,
            quantity: cartItem.quantity,
            priceAtPurchase: product.priceInFcfa,
          ),
        );
      }
    }

    if (orderItems.isEmpty) {
      throw Exception('Aucun produit valide dans le panier');
    }

    // Calculer le total
    final totalAmount = orderItems.fold<int>(
      0,
      (sum, item) => sum + item.subtotal,
    );

    // Créer la commande
    final order = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      items: orderItems,
      totalAmount: totalAmount,
      deliveryFee: deliveryFee,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
      deliveryCity: deliveryCity,
      notes: notes,
    );

    // Ajouter à la liste
    state = [...state, order];

    // Vider le panier des produits sélectionnés
    final cartNotifier = ref.read(cartProvider.notifier);
    for (final item in selectedItems) {
      cartNotifier.removeProduct(item.productId);
    }

    return order.id;
  }

  /// Mettre à jour le statut d'une commande
  void updateOrderStatus(String orderId, OrderStatus status) {
    state = state.map((order) {
      if (order.id == orderId) {
        return Order(
          id: order.id,
          userId: order.userId,
          items: order.items,
          totalAmount: order.totalAmount,
          deliveryFee: order.deliveryFee,
          status: status,
          createdAt: order.createdAt,
          deliveryAddress: order.deliveryAddress,
          deliveryCity: order.deliveryCity,
          notes: order.notes,
        );
      }
      return order;
    }).toList();
  }

  /// Obtenir les commandes d'un utilisateur
  List<Order> getUserOrders(String userId) {
    return state.where((order) => order.userId == userId).toList();
  }

  Product? _getProductById(String productId) {
    try {
      final products = ref.read(productProvider);
      return products.firstWhere(
        (p) => p.id == productId,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Provider pour les commandes
final orderProvider = NotifierProvider<OrderNotifier, List<Order>>(
  () => OrderNotifier(),
);

/// Provider pour les commandes de l'utilisateur connecté
final userOrdersProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(orderProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return orders.where((order) => order.userId == user.id).toList();
});

/// Provider pour les commandes par statut
final ordersByStatusProvider = Provider.family<List<Order>, OrderStatus>(
  (ref, status) {
    final orders = ref.watch(userOrdersProvider);
    return orders.where((order) => order.status == status).toList();
  },
);

