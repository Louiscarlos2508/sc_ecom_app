/// Modèle Product pour ECONOMAX
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInFcfa,
    required this.imageUrl, // Image principale (pour compatibilité)
    required this.imageUrls, // Liste de toutes les images
    required this.sellerId,
    required this.sellerName,
    required this.city,
    this.isSecondHand = false,
    this.isVerifiedWholesaler = false,
    this.isReported = false,
    this.reportReason,
    this.isTradable = false, // Peut être troqué
    this.tradeDescription, // Description pour le troc
  });

  final String id;
  final String name;
  final String description;
  final int priceInFcfa;
  final String imageUrl; // Image principale (déprécié, utiliser imageUrls[0])
  final List<String> imageUrls; // Toutes les images du produit
  final String sellerId;
  final String sellerName;
  final String city; // Ouagadougou, Bobo, Koudougou, etc.
  final bool isSecondHand;
  final bool isVerifiedWholesaler;
  final bool isReported;
  final String? reportReason;
  final bool isTradable; // Peut être troqué
  final String? tradeDescription; // Description pour le troc

  factory Product.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['imageUrl'] as String? ?? '';
    final imageUrlsJson = json['imageUrls'] as List<dynamic>?;
    final List<String> imageUrls = imageUrlsJson != null
        ? imageUrlsJson.map<String>((e) => e as String).toList()
        : (imageUrl.isNotEmpty ? [imageUrl] : <String>[]);

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      priceInFcfa: json['priceInFcfa'] as int,
      imageUrl: imageUrls.isNotEmpty ? imageUrls[0] : '',
      imageUrls: imageUrls,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      city: json['city'] as String,
      isSecondHand: json['isSecondHand'] as bool? ?? false,
      isVerifiedWholesaler: json['isVerifiedWholesaler'] as bool? ?? false,
      isReported: json['isReported'] as bool? ?? false,
      reportReason: json['reportReason'] as String?,
      isTradable: json['isTradable'] as bool? ?? false,
      tradeDescription: json['tradeDescription'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'priceInFcfa': priceInFcfa,
      'imageUrl': imageUrls.isNotEmpty ? imageUrls[0] : '',
      'imageUrls': imageUrls,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'city': city,
      'isSecondHand': isSecondHand,
      'isVerifiedWholesaler': isVerifiedWholesaler,
      'isReported': isReported,
      'reportReason': reportReason,
      'isTradable': isTradable,
      'tradeDescription': tradeDescription,
    };
  }
}

