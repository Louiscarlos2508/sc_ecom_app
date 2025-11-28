import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user.dart';
import '../../../../shared/data/mock_data.dart';

/// Notifier pour l'utilisateur connecté
class CurrentUserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  void setUser(User? user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}

/// Provider pour l'utilisateur connecté
final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, User?>(
  () => CurrentUserNotifier(),
);

/// Provider pour vérifier si l'utilisateur est connecté
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Provider pour vérifier si l'utilisateur est vendeur
final isSellerProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isSeller ?? false;
});

/// Provider pour vérifier si l'utilisateur est admin
final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isAdmin ?? false;
});

/// Provider pour vérifier si l'utilisateur est vendeur grossiste
final isWholesalerProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isWholesaler ?? false;
});

/// Provider pour la liste des utilisateurs de test
final testUsersProvider = Provider<List<User>>((ref) {
  return MockData.defaultUsers;
});

