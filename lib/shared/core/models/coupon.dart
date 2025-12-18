/// Modèle Coupon pour ECONOMAX
class Coupon {
  const Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.validFrom,
    required this.validUntil,
    this.minimumPurchase,
    this.maximumDiscount,
    this.usageLimit,
    this.usedCount = 0,
    this.isActive = true,
  });

  final String id;
  final String code; // Code du coupon (ex: "ECOMAX2024")
  final String description; // Description du coupon
  final DiscountType discountType; // Type de réduction
  final int discountValue; // Valeur de la réduction (en pourcentage ou FCFA)
  final DateTime validFrom; // Date de début de validité
  final DateTime validUntil; // Date de fin de validité
  final int? minimumPurchase; // Montant minimum d'achat en FCFA
  final int? maximumDiscount; // Réduction maximale en FCFA (pour les pourcentages)
  final int? usageLimit; // Limite d'utilisation (null = illimité)
  final int usedCount; // Nombre de fois utilisé
  final bool isActive; // Si le coupon est actif

  /// Vérifie si le coupon est valide
  bool get isValid {
    if (!isActive) return false;
    final now = DateTime.now();
    if (now.isBefore(validFrom) || now.isAfter(validUntil)) return false;
    if (usageLimit != null && usedCount >= usageLimit!) return false;
    return true;
  }

  /// Calcule la réduction pour un montant donné
  int calculateDiscount(int amount) {
    if (!isValid) return 0;
    if (minimumPurchase != null && amount < minimumPurchase!) return 0;

    int discount = 0;
    if (discountType == DiscountType.percentage) {
      discount = (amount * discountValue / 100).round();
      if (maximumDiscount != null && discount > maximumDiscount!) {
        discount = maximumDiscount!;
      }
    } else {
      discount = discountValue;
      if (discount > amount) discount = amount;
    }

    return discount;
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      code: json['code'] as String,
      description: json['description'] as String,
      discountType: DiscountType.values.firstWhere(
        (e) => e.name == json['discountType'],
        orElse: () => DiscountType.percentage,
      ),
      discountValue: json['discountValue'] as int,
      validFrom: DateTime.parse(json['validFrom'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
      minimumPurchase: json['minimumPurchase'] as int?,
      maximumDiscount: json['maximumDiscount'] as int?,
      usageLimit: json['usageLimit'] as int?,
      usedCount: json['usedCount'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discountType': discountType.name,
      'discountValue': discountValue,
      'validFrom': validFrom.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'minimumPurchase': minimumPurchase,
      'maximumDiscount': maximumDiscount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
    };
  }
}

/// Type de réduction
enum DiscountType {
  percentage, // Réduction en pourcentage
  fixed, // Réduction fixe en FCFA
}

