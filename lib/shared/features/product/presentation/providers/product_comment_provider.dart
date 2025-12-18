import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/models/product_comment.dart';
import 'package:economax/shared/core/models/order.dart';
import 'package:economax/shared/core/data/mock_data.dart';
import 'package:economax/shared/core/utils/validators.dart';
import 'package:economax/shared/core/utils/security_utils.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import 'package:economax/features/client/orders/presentation/providers/order_provider.dart';

/// Notifier pour les commentaires de produits
class ProductCommentNotifier extends Notifier<Map<String, List<ProductComment>>> {
  @override
  Map<String, List<ProductComment>> build() {
    // Initialiser avec les données mock
    final Map<String, List<ProductComment>> commentsMap = {};
    for (final comment in MockData.demoComments) {
      commentsMap.putIfAbsent(comment.productId, () => []).add(comment);
    }
    return commentsMap;
  }

  /// Ajouter un commentaire (seulement si l'utilisateur a acheté le produit)
  Future<void> addComment({
    required String productId,
    required String userId,
    required String userName,
    required String comment,
    required int rating,
  }) async {
    // Valider les entrées
    if (!SecurityUtils.isValidId(productId)) {
      throw Exception('ID de produit invalide');
    }
    if (!SecurityUtils.isValidId(userId)) {
      throw Exception('ID d\'utilisateur invalide');
    }

    // Valider le commentaire
    final commentError = Validators.validateComment(comment);
    if (commentError != null) {
      throw Exception(commentError);
    }

    // Valider la note
    final ratingError = Validators.validateRating(rating);
    if (ratingError != null) {
      throw Exception(ratingError);
    }

    // Vérifier que l'utilisateur a acheté le produit
    final orders = ref.read(orderProvider);
    final user = ref.read(currentUserProvider);
    if (user == null || user.id != userId) {
      throw Exception('Utilisateur non autorisé');
    }

    if (!SecurityUtils.canCommentProduct(user, productId, orders)) {
      throw Exception(
        'Vous devez avoir acheté et reçu ce produit pour pouvoir commenter',
      );
    }

    // Sanitizer les entrées
    final sanitizedComment = SecurityUtils.sanitizeInput(comment);
    final sanitizedUserName = SecurityUtils.sanitizeInput(userName);

    final orderInfo = await _getUserOrderForProduct(userId, productId);
    if (orderInfo == null) {
      throw Exception(
        'Vous devez avoir acheté et reçu ce produit pour pouvoir commenter',
      );
    }

    final newComment = ProductComment(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      productId: productId,
      userId: userId,
      userName: sanitizedUserName,
      comment: sanitizedComment,
      rating: rating,
      createdAt: DateTime.now(),
      orderId: orderInfo.orderId,
    );

    final currentComments = state[productId] ?? [];
    state = {
      ...state,
      productId: [...currentComments, newComment],
    };
  }

  /// Obtenir les commentaires d'un produit
  List<ProductComment> getProductComments(String productId) {
    return state[productId] ?? [];
  }

  /// Obtenir la commande de l'utilisateur pour un produit (livrée)
  Future<({String orderId})?> _getUserOrderForProduct(
    String userId,
    String productId,
  ) async {
    final orders = ref.read(orderProvider);
    for (final order in orders) {
      if (order.userId == userId && order.status == OrderStatus.delivered) {
        final hasProduct = order.items.any(
          (item) => item.product.id == productId,
        );
        if (hasProduct) {
          return (orderId: order.id);
        }
      }
    }
    return null;
  }
}

/// Provider pour les commentaires
final productCommentProvider =
    NotifierProvider<ProductCommentNotifier, Map<String, List<ProductComment>>>(
  () => ProductCommentNotifier(),
);

/// Provider pour les commentaires d'un produit spécifique
final productCommentsByProductIdProvider =
    Provider.family<List<ProductComment>, String>(
  (ref, productId) {
    final comments = ref.watch(productCommentProvider);
    return comments[productId] ?? [];
  },
);

