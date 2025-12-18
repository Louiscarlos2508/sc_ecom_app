import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/core/models/order.dart';
import '../../../../../shared/core/models/product.dart';
import '../../../../../shared/core/models/cart_item.dart';
import '../../../../../shared/core/data/mock_data.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import 'package:economax/shared/features/product/presentation/providers/product_provider.dart';

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
    final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';
    final deliveryCode = Order.generateDeliveryCode(orderId);
    
    final order = Order(
      id: orderId,
      userId: userId,
      items: orderItems,
      totalAmount: totalAmount,
      deliveryFee: deliveryFee,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
      deliveryCity: deliveryCity,
      notes: notes,
      deliveryCode: deliveryCode,
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
        final now = DateTime.now();
        return order.copyWith(
          status: status,
          paidAt: status == OrderStatus.paid
              ? (order.paidAt ?? now)
              : order.paidAt,
          shippedAt: status == OrderStatus.shipped
              ? (order.shippedAt ?? now)
              : order.shippedAt,
          deliveredAt: status == OrderStatus.delivered
              ? (order.deliveredAt ?? now)
              : order.deliveredAt,
        );
      }
      return order;
    }).toList();
  }
  
  /// Marquer une commande comme payée
  void markOrderAsPaid(String orderId, String paymentMethod, String transactionId) {
    state = state.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          status: OrderStatus.paid,
          paymentMethod: paymentMethod,
          paymentTransactionId: transactionId,
          paidAt: DateTime.now(),
        );
      }
      return order;
    }).toList();
  }
  
  /// Marquer une commande comme expédiée (pour vendeur)
  void markOrderAsShipped(String orderId) {
    state = state.map((order) {
      if (order.id == orderId) {
        final now = DateTime.now();
        // Générer le deliveryCode s'il n'existe pas encore
        final deliveryCode = order.deliveryCode ?? Order.generateDeliveryCode(orderId);
        return order.copyWith(
          status: OrderStatus.shipped,
          shippedAt: order.shippedAt ?? now,
          deliveryCode: deliveryCode,
        );
      }
      return order;
    }).toList();
  }
  
  /// Marquer une commande comme livrée (pour client)
  void markOrderAsDelivered(String orderId) {
    updateOrderStatus(orderId, OrderStatus.delivered);
  }
  
  /// Noter une commande
  void rateOrder(String orderId, int rating, String? comment) {
    state = state.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          rating: rating,
          ratingComment: comment,
          ratedAt: DateTime.now(),
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

/// Provider pour les commandes à noter (livrées mais pas encore notées)
final ordersToRateProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(userOrdersProvider);
  return orders.where((order) => order.canBeRated).toList();
});

/// Provider pour les commandes expédiées (peuvent être marquées comme reçues)
final ordersToReceiveProvider = Provider<List<Order>>((ref) {
  final orders = ref.watch(userOrdersProvider);
  return orders.where((order) => order.canBeMarkedAsReceived).toList();
});

/// Provider pour les commandes d'un vendeur
final sellerOrdersProvider = Provider.family<List<Order>, String>(
  (ref, sellerId) {
    final orders = ref.watch(orderProvider);
    return orders.where((order) {
      // Vérifier si au moins un produit de la commande appartient au vendeur
      return order.items.any((item) => item.product.sellerId == sellerId);
    }).toList();
  },
);

/// Provider pour les commandes d'un vendeur par statut
final sellerOrdersByStatusProvider = Provider.family<List<Order>, ({String sellerId, OrderStatus status})>(
  (ref, params) {
    final orders = ref.watch(sellerOrdersProvider(params.sellerId));
    return orders.where((order) => order.status == params.status).toList();
  },
);
