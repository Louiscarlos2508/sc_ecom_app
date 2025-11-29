import '../models/user.dart';
import '../models/product.dart';
import '../models/order.dart';

/// Utilitaires de sécurité pour ECONOMAX
class SecurityUtils {
  SecurityUtils._();

  /// Vérifier si un utilisateur peut modifier un produit
  static bool canModifyProduct(User user, Product product) {
    // Seul le vendeur propriétaire peut modifier son produit
    return user.isSeller && product.sellerId == user.id;
  }

  /// Vérifier si un utilisateur peut supprimer un produit
  static bool canDeleteProduct(User user, Product product) {
    // Seul le vendeur propriétaire peut supprimer son produit
    return user.isSeller && product.sellerId == user.id;
  }

  /// Vérifier si un utilisateur peut voir les commandes d'un vendeur
  static bool canViewSellerOrders(User user, String sellerId) {
    // Le vendeur peut voir ses propres commandes, l'admin peut tout voir
    return user.isAdmin || (user.isSeller && user.id == sellerId);
  }

  /// Vérifier si un utilisateur peut modifier une commande
  static bool canModifyOrder(User user, Order order) {
    // Seul le client propriétaire ou l'admin peut modifier une commande
    return user.isAdmin || order.userId == user.id;
  }

  /// Vérifier si un utilisateur peut annuler une commande
  static bool canCancelOrder(User user, Order order) {
    // Seul le client propriétaire peut annuler sa commande (si elle n'est pas encore expédiée)
    if (user.id != order.userId) return false;
    return order.status == OrderStatus.pending ||
        order.status == OrderStatus.paid;
  }

  /// Vérifier si un utilisateur peut commenter un produit
  static bool canCommentProduct(User user, String productId, List<Order> orders) {
    // L'utilisateur doit avoir acheté et reçu le produit
    return orders.any(
      (order) =>
          order.userId == user.id &&
          order.status == OrderStatus.delivered &&
          order.items.any((item) => item.product.id == productId),
    );
  }

  /// Vérifier si un utilisateur peut proposer un troc
  static bool canProposeTrade(User user, Product product) {
    // L'utilisateur ne peut pas proposer un troc sur son propre produit
    if (product.sellerId == user.id) return false;
    // Le produit doit être troquable
    return product.isTradable;
  }

  /// Vérifier si un utilisateur peut gérer les vendeurs (admin uniquement)
  static bool canManageSellers(User user) {
    return user.isAdmin;
  }

  /// Vérifier si un utilisateur peut approuver un grossiste (admin uniquement)
  static bool canApproveWholesaler(User user) {
    return user.isAdmin;
  }

  /// Vérifier si un utilisateur peut bloquer un vendeur (admin uniquement)
  static bool canBlockSeller(User user) {
    return user.isAdmin;
  }

  /// Vérifier si un utilisateur peut marquer un vendeur (admin uniquement)
  static bool canFlagSeller(User user) {
    return user.isAdmin;
  }

  /// Vérifier si un vendeur peut vendre (doit être approuvé si grossiste)
  static bool canSell(User user) {
    if (!user.isSeller) return false;
    // Si c'est un grossiste, il doit être approuvé
    if (user.isWholesaler && !user.isWholesalerApproved) {
      return false;
    }
    return true;
  }

  /// Vérifier si un utilisateur peut accéder au dashboard admin
  static bool canAccessAdminDashboard(User user) {
    return user.isAdmin;
  }

  /// Vérifier si un utilisateur peut accéder au dashboard vendeur
  static bool canAccessSellerDashboard(User user) {
    return user.isSeller;
  }

  /// Sanitizer pour les entrées utilisateur (protection XSS basique)
  static String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .trim();
  }

  /// Valider un ID (protection contre injection)
  static bool isValidId(String? id) {
    if (id == null || id.isEmpty) return false;
    // Un ID doit être alphanumérique et avoir une longueur raisonnable
    final idRegex = RegExp(r'^[a-zA-Z0-9_-]{1,50}$');
    return idRegex.hasMatch(id);
  }
}

