import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

/// Écran des ventes du vendeur
class SellerOrdersScreen extends StatelessWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Mes ventes'),
      ),
      body: const Center(
        child: Text('Historique de vos ventes'),
      ),
    );
  }
}

