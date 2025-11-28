import '../models/product.dart';
import '../models/user.dart';

/// Données de test pour ECONOMAX
class MockData {
  MockData._();

  /// Utilisateurs par défaut pour tester
  static final List<User> defaultUsers = [
    const User(
      id: 'user1',
      name: 'Amadou Traoré',
      email: 'amadou@economax.bf',
      phone: '+226 70 12 34 56',
      city: 'Ouagadougou',
      isSeller: true,
      isWholesaler: true, // Vendeur grossiste vérifié
      referralCode: 'AMADOU2024',
    ),
    const User(
      id: 'user2',
      name: 'Fatou Diallo',
      email: 'fatou@economax.bf',
      phone: '+226 76 23 45 67',
      city: 'Bobo-Dioulasso',
      isSeller: true,
      isWholesaler: false, // Vendeur simple
      referralCode: 'FATOU2024',
    ),
    const User(
      id: 'user3',
      name: 'Ibrahim Sawadogo',
      email: 'ibrahim@economax.bf',
      phone: '+226 70 34 56 78',
      city: 'Koudougou',
      isSeller: false,
      referralCode: 'IBRAHIM2024',
    ),
    const User(
      id: 'admin1',
      name: 'Équipe ECONOMAX',
      email: 'admin@economax.bf',
      phone: '+226 25 50 00 00',
      city: 'Ouagadougou',
      isAdmin: true,
    ),
  ];

  /// Produits de démonstration
  static final List<Product> demoProducts = [
    Product(
      id: 'prod1',
      name: 'Riz local premium',
      description: 'Riz de qualité supérieure, récolté localement',
      priceInFcfa: 2500,
      imageUrl: 'https://picsum.photos/300/300?random=1',
      imageUrls: [
        'https://picsum.photos/300/300?random=1',
        'https://picsum.photos/300/300?random=11',
        'https://picsum.photos/300/300?random=12',
      ],
      sellerId: 'user1',
      sellerName: 'Amadou Traoré',
      city: 'Ouagadougou',
      isVerifiedWholesaler: true,
    ),
    Product(
      id: 'prod2',
      name: 'Téléphone Android',
      description: 'Smartphone Android, état excellent',
      priceInFcfa: 45000,
      imageUrl: 'https://picsum.photos/300/300?random=2',
      imageUrls: [
        'https://picsum.photos/300/300?random=2',
        'https://picsum.photos/300/300?random=21',
        'https://picsum.photos/300/300?random=22',
      ],
      sellerId: 'user2',
      sellerName: 'Fatou Diallo',
      city: 'Bobo-Dioulasso',
      isSecondHand: true,
      isTradable: true,
      tradeDescription: 'Accepte troc contre téléphone iPhone ou ordinateur',
    ),
    Product(
      id: 'prod3',
      name: 'Arachides grillées',
      description: 'Arachides fraîches, grillées à la burkinabè',
      priceInFcfa: 1500,
      imageUrl: 'https://picsum.photos/300/300?random=3',
      imageUrls: [
        'https://picsum.photos/300/300?random=3',
        'https://picsum.photos/300/300?random=31',
      ],
      sellerId: 'user1',
      sellerName: 'Amadou Traoré',
      city: 'Ouagadougou',
      isVerifiedWholesaler: true,
    ),
    Product(
      id: 'prod4',
      name: 'Vélo d\'occasion',
      description: 'Vélo en bon état, parfait pour la ville',
      priceInFcfa: 35000,
      imageUrl: 'https://picsum.photos/300/300?random=4',
      imageUrls: [
        'https://picsum.photos/300/300?random=4',
        'https://picsum.photos/300/300?random=41',
        'https://picsum.photos/300/300?random=42',
        'https://picsum.photos/300/300?random=43',
      ],
      sellerId: 'user2',
      sellerName: 'Fatou Diallo',
      city: 'Bobo-Dioulasso',
      isSecondHand: true,
      isTradable: true,
      tradeDescription: 'Accepte troc contre moto ou autre véhicule',
    ),
    Product(
      id: 'prod5',
      name: 'Maïs local',
      description: 'Maïs frais, récolte du mois',
      priceInFcfa: 1200,
      imageUrl: 'https://picsum.photos/300/300?random=5',
      imageUrls: [
        'https://picsum.photos/300/300?random=5',
      ],
      sellerId: 'user1',
      sellerName: 'Amadou Traoré',
      city: 'Ouagadougou',
      isVerifiedWholesaler: true,
    ),
    Product(
      id: 'prod6',
      name: 'Télévision LED',
      description: 'TV LED 32 pouces, presque neuve',
      priceInFcfa: 85000,
      imageUrl: 'https://picsum.photos/300/300?random=6',
      imageUrls: [
        'https://picsum.photos/300/300?random=6',
        'https://picsum.photos/300/300?random=61',
      ],
      sellerId: 'user2',
      sellerName: 'Fatou Diallo',
      city: 'Bobo-Dioulasso',
      isSecondHand: true,
    ),
  ];
}

