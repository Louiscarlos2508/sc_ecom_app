import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

/// Liste des commandes
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Mes commandes'),
      ),
      body: const Center(
        child: Text('Aucune commande pour le moment'),
      ),
    );
  }
}

