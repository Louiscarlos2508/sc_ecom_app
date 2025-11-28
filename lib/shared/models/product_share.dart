/// Modèle Partage produit (réseaux sociaux avec lien spécifique)
class ProductShare {
  const ProductShare({
    required this.id,
    required this.productId,
    required this.userId, // Utilisateur qui partage
    required this.shareCode, // Code unique pour le lien
    required this.platform, // whatsapp, facebook, instagram, tiktok
    required this.createdAt,
  });

  final String id;
  final String productId;
  final String userId;
  final String shareCode; // Code unique généré
  final SharePlatform platform;
  final DateTime createdAt;

  factory ProductShare.fromJson(Map<String, dynamic> json) {
    return ProductShare(
      id: json['id'] as String,
      productId: json['productId'] as String,
      userId: json['userId'] as String,
      shareCode: json['shareCode'] as String,
      platform: SharePlatform.values.firstWhere(
        (e) => e.name == json['platform'],
        orElse: () => SharePlatform.whatsapp,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'shareCode': shareCode,
      'platform': platform.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Génère le lien de partage unique
  String getShareUrl(String baseUrl) {
    return '$baseUrl/product/$productId?ref=$shareCode';
  }
}

enum SharePlatform {
  whatsapp,
  facebook,
  instagram,
  tiktok,
  whatsappStatus,
}

