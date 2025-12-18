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
    this.paymentMethod,
    this.paymentTransactionId,
    this.paidAt,
    this.shippedAt,
    this.deliveredAt,
    this.rating,
    this.ratingComment,
    this.ratedAt,
    this.deliveryCode, // Code unique pour la livraison (généré automatiquement)
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
  final String? paymentMethod; // "Orange Money", "Moov Money", "Wave", "Telecel Money", "BTC", "USDT", "ETH"
  final String? paymentTransactionId; // ID de transaction du paiement
  final DateTime? paidAt; // Date de paiement
  final DateTime? shippedAt; // Date d'expédition
  final DateTime? deliveredAt; // Date de livraison
  final int? rating; // Note de 1 à 5
  final String? ratingComment; // Commentaire de l'évaluation
  final DateTime? ratedAt; // Date d'évaluation
  final String? deliveryCode; // Code unique pour la livraison (ex: "ECM-1234-ABCD")

  int get grandTotal => totalAmount + deliveryFee;
  
  /// Génère un code de livraison unique
  static String generateDeliveryCode(String orderId) {
    // Format: ECM-[4 chiffres]-[4 lettres aléatoires]
    // Utiliser l'ID de commande pour garantir l'unicité
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toInt();
    final letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ'; // Sans I et O pour éviter confusion
    // Utiliser le hash de l'ID de commande pour générer les lettres
    final hash = orderId.hashCode.abs();
    final randomLetters = List.generate(4, (index) {
      final letterIndex = (hash + timestamp + index) % letters.length;
      return letters[letterIndex];
    }).join();
    return 'ECM-${random.toString().padLeft(4, '0')}-$randomLetters';
  }
  
  /// Vérifie si la commande peut être notée (livrée et pas encore notée)
  bool get canBeRated => status == OrderStatus.delivered && rating == null;
  
  /// Vérifie si la commande peut être marquée comme reçue (expédiée mais pas encore livrée)
  bool get canBeMarkedAsReceived => status == OrderStatus.shipped;

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
      paymentMethod: json['paymentMethod'] as String?,
      paymentTransactionId: json['paymentTransactionId'] as String?,
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'] as String)
          : null,
      shippedAt: json['shippedAt'] != null
          ? DateTime.parse(json['shippedAt'] as String)
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
      rating: json['rating'] as int?,
      ratingComment: json['ratingComment'] as String?,
      ratedAt: json['ratedAt'] != null
          ? DateTime.parse(json['ratedAt'] as String)
          : null,
      deliveryCode: json['deliveryCode'] as String?,
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
      'paymentMethod': paymentMethod,
      'paymentTransactionId': paymentTransactionId,
      'paidAt': paidAt?.toIso8601String(),
      'shippedAt': shippedAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'rating': rating,
      'ratingComment': ratingComment,
      'ratedAt': ratedAt?.toIso8601String(),
      'deliveryCode': deliveryCode,
    };
  }
  
  /// Crée une copie de la commande avec des champs modifiés
  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    int? totalAmount,
    int? deliveryFee,
    OrderStatus? status,
    DateTime? createdAt,
    String? deliveryAddress,
    String? deliveryCity,
    String? notes,
    String? paymentMethod,
    String? paymentTransactionId,
    DateTime? paidAt,
    DateTime? shippedAt,
    DateTime? deliveredAt,
    int? rating,
    String? ratingComment,
    DateTime? ratedAt,
    String? deliveryCode,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryCity: deliveryCity ?? this.deliveryCity,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      paidAt: paidAt ?? this.paidAt,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      rating: rating ?? this.rating,
      ratingComment: ratingComment ?? this.ratingComment,
      ratedAt: ratedAt ?? this.ratedAt,
      deliveryCode: deliveryCode ?? this.deliveryCode,
    );
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

