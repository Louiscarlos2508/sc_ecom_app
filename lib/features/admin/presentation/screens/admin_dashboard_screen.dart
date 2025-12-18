import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/core/theme/app_colors.dart';
import '../../../../shared/core/data/mock_data.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../client/orders/presentation/screens/delivery_verification_screen.dart';
import '../providers/admin_navigation_provider.dart';

/// Dashboard équipe ECONOMAX
/// Marquer/bloquer vendeurs avec raison publique
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalUsers = MockData.defaultUsers.length;
    final totalSellers = MockData.defaultUsers.where((u) => u.isSeller).length;
    final totalProducts = MockData.demoProducts.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Dashboard Admin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message de bienvenue
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Équipe ECONOMAX',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestion de la plateforme',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Statistiques
            Row(
              children: [
                Expanded(
                  child: _AdminStatCard(
                    title: 'Utilisateurs',
                    value: '$totalUsers',
                    icon: Icons.people,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _AdminStatCard(
                    title: 'Vendeurs',
                    value: '$totalSellers',
                    icon: Icons.store,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _AdminStatCard(
                    title: 'Produits',
                    value: '$totalProducts',
                    icon: Icons.shopping_bag,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _AdminStatCard(
                    title: 'Signalés',
                    value: '0',
                    icon: Icons.flag,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Actions rapides
            Text(
              'Actions rapides',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _AdminActionCard(
              icon: Icons.store,
              title: 'Gérer les vendeurs',
              description: 'Marquer ou bloquer des vendeurs',
              color: AppColors.error,
              onTap: () {
                // Navigation vers gestion vendeurs
                ref.read(adminNavigationIndexProvider.notifier).setIndex(1);
              },
            ),
            const SizedBox(height: 12),
            _AdminActionCard(
              icon: Icons.flag,
              title: 'Vendeurs signalés',
              description: 'Voir les vendeurs signalés',
              color: AppColors.warning,
              onTap: () {
                // TODO: Naviguer vers vendeurs signalés
              },
            ),
            const SizedBox(height: 12),
            _AdminActionCard(
              icon: Icons.qr_code_scanner,
              title: 'Vérification livraison',
              description: 'Scanner et vérifier les codes de livraison',
              color: AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeliveryVerificationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte de statistique admin
class _AdminStatCard extends StatelessWidget {
  const _AdminStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

/// Carte d'action admin
class _AdminActionCard extends StatelessWidget {
  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
