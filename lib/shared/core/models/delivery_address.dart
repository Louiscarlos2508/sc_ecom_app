/// Modèle Adresse de livraison pour ECONOMAX
class DeliveryAddress {
  const DeliveryAddress({
    required this.id,
    required this.userId,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.address,
    this.landmark,
    this.isDefault = false,
  });

  final String id;
  final String userId;
  final String label; // "Maison", "Bureau", "Autre"
  final String fullName; // Nom complet du destinataire
  final String phone; // Téléphone du destinataire
  final String city; // Ville (Ouagadougou, Bobo, Koudougou, etc.)
  final String address; // Adresse complète
  final String? landmark; // Point de repère (optionnel)
  final bool isDefault; // Adresse par défaut

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'] as String,
      userId: json['userId'] as String,
      label: json['label'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      landmark: json['landmark'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'address': address,
      'landmark': landmark,
      'isDefault': isDefault,
    };
  }

  DeliveryAddress copyWith({
    String? id,
    String? userId,
    String? label,
    String? fullName,
    String? phone,
    String? city,
    String? address,
    String? landmark,
    bool? isDefault,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      address: address ?? this.address,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

