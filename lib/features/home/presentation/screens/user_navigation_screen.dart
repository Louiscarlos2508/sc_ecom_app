import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'main_navigation_screen.dart';
import '../../../seller/presentation/screens/seller_navigation_screen.dart';
import '../../../admin/presentation/screens/admin_navigation_screen.dart';

/// Écran de navigation selon le type d'utilisateur
/// Redirige vers le bon dashboard selon le rôle
class UserNavigationScreen extends ConsumerWidget {
  const UserNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      // Pas d'utilisateur connecté, ne devrait pas arriver
      return const Scaffold(
        body: Center(child: Text('Erreur: Aucun utilisateur connecté')),
      );
    }

    // Rediriger selon le type d'utilisateur
    if (user.isAdmin) {
      return const AdminNavigationScreen();
    } else if (user.isSeller) {
      return const SellerNavigationScreen();
    } else {
      // Client par défaut
      return const MainNavigationScreen();
    }
  }
}

