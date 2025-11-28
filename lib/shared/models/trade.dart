/// Modèle Troc (échange de produits)
class Trade {
  const Trade({
    required this.id,
    required this.productId, // Produit proposé
    required this.sellerId,
    required this.buyerId,
    required this.buyerProductId, // Produit proposé en échange
    required this.status, // pending, accepted, rejected, completed
    required this.createdAt,
    this.message,
  });

  final String id;
  final String productId;
  final String sellerId;
  final String buyerId;
  final String buyerProductId;
  final TradeStatus status;
  final DateTime createdAt;
  final String? message;

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id'] as String,
      productId: json['productId'] as String,
      sellerId: json['sellerId'] as String,
      buyerId: json['buyerId'] as String,
      buyerProductId: json['buyerProductId'] as String,
      status: TradeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TradeStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'buyerProductId': buyerProductId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'message': message,
    };
  }
}

enum TradeStatus {
  pending, // En attente
  accepted, // Accepté
  rejected, // Refusé
  completed, // Terminé
}

