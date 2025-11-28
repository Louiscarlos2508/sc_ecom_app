import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/widgets/verified_wholesaler_badge.dart';
import 'seller_company_info_screen.dart';

/// Dashboard vendeur burkinabè
class SellerDashboardScreen extends ConsumerWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isWholesaler = ref.watch(isWholesalerProvider);
    final myProducts = MockData.demoProducts
        .where((p) => p.sellerId == user?.id)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Dashboard Vendeur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.business),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SellerCompanyInfoScreen(),
                ),
              );
            },
            tooltip: 'Informations entreprise',
          ),
        ],
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
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Bienvenue ${user?.name ?? "Vendeur"} !',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      if (isWholesaler)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Grossiste',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isWholesaler
                        ? 'Vendeur grossiste vérifié - Gérez vos produits et ventes'
                        : 'Vendeur simple - Gérez vos produits et ventes',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Avertissement si grossiste non approuvé
            if (user?.isWholesaler == true && !user!.isWholesalerApproved)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.warning),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Votre compte grossiste est en attente de confirmation par l\'équipe ECONOMAX. Vous ne pourrez pas vendre tant que votre compte n\'est pas approuvé.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.warning,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            if (user?.isWholesaler == true && !user!.isWholesalerApproved)
              const SizedBox(height: 24),
            // Statistiques rapides
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Produits',
                    value: '${myProducts.length}',
                    icon: Icons.inventory_2,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Ventes',
                    value: '0',
                    icon: Icons.shopping_bag,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Produits récents
            Text(
              'Mes produits',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (myProducts.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun produit pour le moment',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Naviguer vers ajout produit
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                      ),
                      child: const Text('Ajouter un produit'),
                    ),
                  ],
                ),
              )
            else
              ...myProducts.map((product) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.secondary,
                        child: Icon(
                          Icons.shopping_bag,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text('${product.priceInFcfa} FCFA'),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

/// Carte de statistique
class _StatCard extends StatelessWidget {
  const _StatCard({
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
