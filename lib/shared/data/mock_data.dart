import '../models/product.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/product_comment.dart';
import '../models/trade.dart';

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
      minimumQuantity: 10, // Quantité minimale pour grossiste
      wholesalePrice: 2200, // Prix de gros (10% de réduction)
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
      minimumQuantity: 5, // Quantité minimale pour grossiste
      wholesalePrice: 1300, // Prix de gros
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
      minimumQuantity: 20, // Quantité minimale pour grossiste
      wholesalePrice: 1000, // Prix de gros
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

  /// Commandes de démonstration
  static final List<Order> demoOrders = [
    Order(
      id: 'order1',
      userId: 'user3',
      items: [
        OrderItem(
          product: demoProducts[0], // Riz local premium
          quantity: 2,
          priceAtPurchase: 2500,
        ),
        OrderItem(
          product: demoProducts[2], // Arachides grillées
          quantity: 5,
          priceAtPurchase: 1500,
        ),
      ],
      totalAmount: 12500, // (2500 * 2) + (1500 * 5)
      deliveryFee: 1000,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      deliveryAddress: 'Secteur 30, Ouagadougou',
      deliveryCity: 'Ouagadougou',
    ),
    Order(
      id: 'order2',
      userId: 'user3',
      items: [
        OrderItem(
          product: demoProducts[1], // Téléphone Android
          quantity: 1,
          priceAtPurchase: 45000,
        ),
      ],
      totalAmount: 45000,
      deliveryFee: 1000,
      status: OrderStatus.shipped,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      deliveryAddress: 'Secteur 30, Ouagadougou',
      deliveryCity: 'Ouagadougou',
    ),
    Order(
      id: 'order3',
      userId: 'user3',
      items: [
        OrderItem(
          product: demoProducts[3], // Vélo d'occasion
          quantity: 1,
          priceAtPurchase: 35000,
        ),
      ],
      totalAmount: 35000,
      deliveryFee: 1000,
      status: OrderStatus.paid,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      deliveryAddress: 'Secteur 30, Ouagadougou',
      deliveryCity: 'Ouagadougou',
    ),
  ];

  /// Commentaires de démonstration
  static final List<ProductComment> demoComments = [
    ProductComment(
      id: 'comment1',
      productId: 'prod1',
      userId: 'user3',
      userName: 'Ibrahim Sawadogo',
      rating: 5,
      comment: 'Excellent riz ! Qualité supérieure, je recommande vivement.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      orderId: 'order1',
    ),
    ProductComment(
      id: 'comment2',
      productId: 'prod1',
      userId: 'user3',
      userName: 'Ibrahim Sawadogo',
      rating: 4,
      comment: 'Très bon produit, livraison rapide. Merci !',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      orderId: 'order1',
    ),
    ProductComment(
      id: 'comment3',
      productId: 'prod2',
      userId: 'user3',
      userName: 'Ibrahim Sawadogo',
      rating: 5,
      comment: 'Téléphone en excellent état, comme neuf. Vendeur sérieux.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      orderId: 'order2',
    ),
  ];

  /// Propositions de troc de démonstration
  static final List<Trade> demoTrades = [
    Trade(
      id: 'trade1',
      productId: 'prod2', // Téléphone Android
      sellerId: 'user2',
      buyerId: 'user3',
      buyerProductId: 'prod4', // Vélo d'occasion
      status: TradeStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      message: 'Bonjour, je propose mon vélo en échange de votre téléphone. Il est en très bon état.',
    ),
    Trade(
      id: 'trade2',
      productId: 'prod4', // Vélo d'occasion
      sellerId: 'user2',
      buyerId: 'user1',
      buyerProductId: 'prod3', // Arachides grillées
      status: TradeStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      message: 'Échange accepté !',
    ),
    Trade(
      id: 'trade3',
      productId: 'prod6', // Télévision LED
      sellerId: 'user2',
      buyerId: 'user1',
      buyerProductId: 'prod1', // Riz local premium
      status: TradeStatus.rejected,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      message: 'Désolé, je ne suis pas intéressé par cet échange.',
    ),
  ];
}

