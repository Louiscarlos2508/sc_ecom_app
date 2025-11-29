import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../providers/admin_provider.dart';

/// Écran de gestion des vendeurs (admin)
class AdminSellersScreen extends ConsumerWidget {
  const AdminSellersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellers = ref.watch(adminSellersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Gestion Vendeurs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sellers.length,
        itemBuilder: (context, index) {
          final seller = sellers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.success,
                child: Icon(
                  Icons.store,
                  color: AppColors.onPrimary,
                ),
              ),
              title: Row(
                children: [
                  Expanded(child: Text(seller.name)),
                  if (seller.isWholesaler)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
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
                              fontSize: 10,
                            ),
                      ),
                    ),
                ],
              ),
              subtitle: Text('${seller.email} • ${seller.city}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  final adminNotifier = ref.read(adminSellersProvider.notifier);
                  
                  if (value == 'block') {
                    adminNotifier.blockSeller(seller.id, 'Raison non spécifiée');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${seller.name} a été bloqué'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  } else if (value == 'mark') {
                    adminNotifier.markSeller(seller.id, 'Raison non spécifiée');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${seller.name} a été marqué'),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                  } else if (value == 'make_wholesaler') {
                    adminNotifier.markAsWholesaler(seller.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${seller.name} est maintenant un vendeur grossiste (en attente d\'approbation)',
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else if (value == 'approve_wholesaler') {
                    adminNotifier.approveWholesaler(seller.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Compte grossiste de ${seller.name} approuvé. Il peut maintenant vendre.',
                        ),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else if (value == 'remove_wholesaler') {
                    adminNotifier.removeWholesalerStatus(seller.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Statut grossiste retiré pour ${seller.name}'),
                        backgroundColor: AppColors.warning,
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  if (!seller.isWholesaler)
                    PopupMenuItem(
                      value: 'make_wholesaler',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user,
                            size: 20,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Marquer comme grossiste',
                          ),
                        ],
                      ),
                    ),
                  if (seller.isWholesaler && !seller.isWholesalerApproved)
                    PopupMenuItem(
                      value: 'approve_wholesaler',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Approuver compte grossiste',
                          ),
                        ],
                      ),
                    ),
                  if (seller.isWholesaler && seller.isWholesalerApproved)
                    PopupMenuItem(
                      value: 'remove_wholesaler',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            size: 20,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Retirer statut grossiste',
                          ),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'mark',
                    child: Row(
                      children: [
                        Icon(Icons.flag, size: 20),
                        SizedBox(width: 8),
                        Text('Marquer'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'block',
                    child: Row(
                      children: [
                        Icon(Icons.block, size: 20, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Bloquer', style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

