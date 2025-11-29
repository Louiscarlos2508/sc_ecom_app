import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/utils/security_utils.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Notifier pour la gestion admin des vendeurs
class AdminNotifier extends Notifier<List<User>> {
  @override
  List<User> build() => MockData.defaultUsers.where((u) => u.isSeller).toList();

  /// Marquer un vendeur comme grossiste
  void markAsWholesaler(String sellerId) {
    // Vérifier les permissions
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null || !SecurityUtils.canManageSellers(currentUser)) {
      throw Exception('Accès non autorisé');
    }

    // Valider l'ID
    if (!SecurityUtils.isValidId(sellerId)) {
      throw Exception('ID de vendeur invalide');
    }

    state = state.map((seller) {
      if (seller.id == sellerId) {
        return User(
          id: seller.id,
          name: seller.name,
          email: seller.email,
          phone: seller.phone,
          city: seller.city,
          isSeller: seller.isSeller,
          isWholesaler: true,
          isWholesalerApproved: false, // Doit être approuvé séparément
          isAdmin: seller.isAdmin,
          referralCode: seller.referralCode,
          referredByCode: seller.referredByCode,
          companyName: seller.companyName,
          companyDescription: seller.companyDescription,
          companyAddress: seller.companyAddress,
          companyEmail: seller.companyEmail,
          companyPhone: seller.companyPhone,
          termsAndConditions: seller.termsAndConditions,
        );
      }
      return seller;
    }).toList();
  }

  /// Approuver un vendeur grossiste
  void approveWholesaler(String sellerId) {
    // Vérifier les permissions
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null || !SecurityUtils.canApproveWholesaler(currentUser)) {
      throw Exception('Accès non autorisé');
    }

    // Valider l'ID
    if (!SecurityUtils.isValidId(sellerId)) {
      throw Exception('ID de vendeur invalide');
    }

    state = state.map((seller) {
      if (seller.id == sellerId) {
        return User(
          id: seller.id,
          name: seller.name,
          email: seller.email,
          phone: seller.phone,
          city: seller.city,
          isSeller: seller.isSeller,
          isWholesaler: seller.isWholesaler,
          isWholesalerApproved: true,
          isAdmin: seller.isAdmin,
          referralCode: seller.referralCode,
          referredByCode: seller.referredByCode,
          companyName: seller.companyName,
          companyDescription: seller.companyDescription,
          companyAddress: seller.companyAddress,
          companyEmail: seller.companyEmail,
          companyPhone: seller.companyPhone,
          termsAndConditions: seller.termsAndConditions,
        );
      }
      return seller;
    }).toList();
  }

  /// Retirer le statut grossiste
  void removeWholesalerStatus(String sellerId) {
    // Vérifier les permissions
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null || !SecurityUtils.canManageSellers(currentUser)) {
      throw Exception('Accès non autorisé');
    }

    // Valider l'ID
    if (!SecurityUtils.isValidId(sellerId)) {
      throw Exception('ID de vendeur invalide');
    }

    state = state.map((seller) {
      if (seller.id == sellerId) {
        return User(
          id: seller.id,
          name: seller.name,
          email: seller.email,
          phone: seller.phone,
          city: seller.city,
          isSeller: seller.isSeller,
          isWholesaler: false,
          isWholesalerApproved: false,
          isAdmin: seller.isAdmin,
          referralCode: seller.referralCode,
          referredByCode: seller.referredByCode,
          companyName: seller.companyName,
          companyDescription: seller.companyDescription,
          companyAddress: seller.companyAddress,
          companyEmail: seller.companyEmail,
          companyPhone: seller.companyPhone,
          termsAndConditions: seller.termsAndConditions,
        );
      }
      return seller;
    }).toList();
  }

  /// Marquer un vendeur (avec raison)
  void markSeller(String sellerId, String reason) {
    // Vérifier les permissions
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null || !SecurityUtils.canFlagSeller(currentUser)) {
      throw Exception('Accès non autorisé');
    }

    // Valider l'ID
    if (!SecurityUtils.isValidId(sellerId)) {
      throw Exception('ID de vendeur invalide');
    }

    // Sanitizer la raison
    final sanitizedReason = SecurityUtils.sanitizeInput(reason);
    if (sanitizedReason.isEmpty || sanitizedReason.length < 10) {
      throw Exception('La raison doit contenir au moins 10 caractères');
    }

    // TODO: Implémenter le système de marquage avec raison publique
    // Pour l'instant, on peut juste logger
  }

  /// Bloquer un vendeur
  void blockSeller(String sellerId, String reason) {
    // Vérifier les permissions
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null || !SecurityUtils.canBlockSeller(currentUser)) {
      throw Exception('Accès non autorisé');
    }

    // Valider l'ID
    if (!SecurityUtils.isValidId(sellerId)) {
      throw Exception('ID de vendeur invalide');
    }

    // Sanitizer la raison
    final sanitizedReason = SecurityUtils.sanitizeInput(reason);
    if (sanitizedReason.isEmpty || sanitizedReason.length < 10) {
      throw Exception('La raison doit contenir au moins 10 caractères');
    }

    // TODO: Implémenter le système de blocage avec raison publique
    // Pour l'instant, on peut juste logger
  }
}

/// Provider pour la gestion admin des vendeurs
final adminSellersProvider = NotifierProvider<AdminNotifier, List<User>>(
  () => AdminNotifier(),
);

