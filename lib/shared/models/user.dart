/// Modèle User pour ECONOMAX
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    this.isSeller = false,
    this.isWholesaler = false, // Vendeur grossiste (doit être vérifié par admin)
    this.isWholesalerApproved = false, // Confirmation admin pour grossiste
    this.isAdmin = false,
    this.isBlocked = false, // Compte bloqué par admin
    this.referralCode,
    this.referredByCode,
    // Données administratives vendeur
    this.companyName,
    this.companyDescription,
    this.companyAddress,
    this.companyEmail,
    this.companyPhone,
    this.termsAndConditions, // Conditions générales de vente
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String city; // Ouagadougou, Bobo, Koudougou, etc.
  final bool isSeller;
  final bool isWholesaler; // Vendeur grossiste vérifié
  final bool isWholesalerApproved; // Confirmation admin pour grossiste
  final bool isAdmin;
  final bool isBlocked; // Compte bloqué par admin
  final String? referralCode;
  final String? referredByCode;
  // Données administratives vendeur
  final String? companyName; // Nom de l'entreprise
  final String? companyDescription; // Présentation de la société
  final String? companyAddress; // Coordonnées géographiques
  final String? companyEmail; // Email de l'entreprise
  final String? companyPhone; // Contact téléphonique entreprise
  final String? termsAndConditions; // Conditions générales de vente

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      city: json['city'] as String,
      isSeller: json['isSeller'] as bool? ?? false,
      isWholesaler: json['isWholesaler'] as bool? ?? false,
      isWholesalerApproved: json['isWholesalerApproved'] as bool? ?? false,
      isAdmin: json['isAdmin'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      referralCode: json['referralCode'] as String?,
      referredByCode: json['referredByCode'] as String?,
      companyName: json['companyName'] as String?,
      companyDescription: json['companyDescription'] as String?,
      companyAddress: json['companyAddress'] as String?,
      companyEmail: json['companyEmail'] as String?,
      companyPhone: json['companyPhone'] as String?,
      termsAndConditions: json['termsAndConditions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'isSeller': isSeller,
      'isWholesaler': isWholesaler,
      'isWholesalerApproved': isWholesalerApproved,
      'isAdmin': isAdmin,
      'isBlocked': isBlocked,
      'referralCode': referralCode,
      'referredByCode': referredByCode,
      'companyName': companyName,
      'companyDescription': companyDescription,
      'companyAddress': companyAddress,
      'companyEmail': companyEmail,
      'companyPhone': companyPhone,
      'termsAndConditions': termsAndConditions,
    };
  }
}

