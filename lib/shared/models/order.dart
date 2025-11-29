import 'product.dart';

/// Statut d'une commande
enum OrderStatus {
  pending, // À payer
  paid, // Payée
  shipping, // À expédier
  shipped, // Expédiée
  delivered, // Livrée
  cancelled, // Annulée
  returned, // Retournée
}

/// Modèle Order pour ECONOMAX
class Order {
  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.status,
    required this.createdAt,
    this.deliveryAddress,
    this.deliveryCity,
    this.notes,
  });

  final String id;
  final String userId;
  final List<OrderItem> items;
  final int totalAmount; // En FCFA
  final int deliveryFee; // En FCFA
  final OrderStatus status;
  final DateTime createdAt;
  final String? deliveryAddress;
  final String? deliveryCity;
  final String? notes;

  int get grandTotal => totalAmount + deliveryFee;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalAmount: json['totalAmount'] as int,
      deliveryFee: json['deliveryFee'] as int,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      deliveryAddress: json['deliveryAddress'] as String?,
      deliveryCity: json['deliveryCity'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress,
      'deliveryCity': deliveryCity,
      'notes': notes,
    };
  }
}

/// Item d'une commande
class OrderItem {
  const OrderItem({
    required this.product,
    required this.quantity,
    required this.priceAtPurchase, // Prix au moment de l'achat
  });

  final Product product;
  final int quantity;
  final int priceAtPurchase; // En FCFA

  int get subtotal => priceAtPurchase * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      priceAtPurchase: json['priceAtPurchase'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'priceAtPurchase': priceAtPurchase,
    };
  }
}

