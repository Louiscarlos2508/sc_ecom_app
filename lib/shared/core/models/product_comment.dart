/// Modèle Commentaire produit (visible seulement après achat confirmé)
class ProductComment {
  const ProductComment({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating, // 1-5 étoiles
    required this.comment,
    required this.createdAt,
    required this.orderId, // ID de la commande confirmée
  });

  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating; // 1-5
  final String comment;
  final DateTime createdAt;
  final String orderId; // Pour vérifier que l'achat est confirmé

  factory ProductComment.fromJson(Map<String, dynamic> json) {
    return ProductComment(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderId: json['orderId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'orderId': orderId,
    };
  }
}

