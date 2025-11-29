import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../order/presentation/screens/order_list_screen.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../../../seller/presentation/screens/seller_dashboard_screen.dart';
import '../../../seller/presentation/screens/seller_company_info_screen.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../troc/presentation/screens/client_trades_screen.dart';
import '../../../troc/presentation/screens/seller_trades_screen.dart';
import '../../../../shared/models/order.dart';
import 'settings_screen.dart';

/// Écran de compte utilisateur (inspiré AliExpress, adapté ECONOMAX)
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isSeller = ref.watch(isSellerProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final isWholesaler = ref.watch(isWholesalerProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Non connecté')),
      );
    }

    // Afficher le contenu selon le type d'utilisateur
    if (isAdmin) {
      return _buildAdminAccount(context, user);
    } else if (isSeller) {
      return _buildSellerAccount(context, user, isWholesaler);
    } else {
      return _buildClientAccount(context, user);
    }
  }

  /// Compte client
  Widget _buildClientAccount(BuildContext context, User user) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header avec avatar et nom
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Mon compte',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.onPrimary,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: AppColors.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Mes commandes
                _AccountSection(
                  title: 'Mes commandes',
                  actionText: 'Voir tout',
                  onActionTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderListScreen(),
                      ),
                    );
                  },
                          children: [
                            Consumer(
                              builder: (context, ref, _) {
                                final orders = ref.watch(userOrdersProvider);
                                final pendingCount = orders
                                    .where((o) => o.status == OrderStatus.pending)
                                    .length;
                                final shippingCount = orders
                                    .where((o) => o.status == OrderStatus.shipping)
                                    .length;
                                final shippedCount = orders
                                    .where((o) => o.status == OrderStatus.shipped)
                                    .length;
                                final toRateCount = orders
                                    .where((o) => o.status == OrderStatus.delivered)
                                    .length;
                                final returnedCount = orders
                                    .where((o) => o.status == OrderStatus.returned)
                                    .length;
                                
                                return _OrderStatusRow(
                                  items: [
                                    _OrderStatusItem(
                                      icon: Icons.payment,
                                      label: 'À payer',
                                      count: pendingCount,
                                    ),
                                    _OrderStatusItem(
                                      icon: Icons.local_shipping,
                                      label: 'À expédier',
                                      count: shippingCount,
                                    ),
                                    _OrderStatusItem(
                                      icon: Icons.delivery_dining,
                                      label: 'Expédiée',
                                      count: shippedCount,
                                    ),
                                    _OrderStatusItem(
                                      icon: Icons.rate_review,
                                      label: 'À noter',
                                      count: toRateCount,
                                    ),
                                    _OrderStatusItem(
                                      icon: Icons.assignment_return,
                                      label: 'Retours',
                                      count: returnedCount,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                ),
                const SizedBox(height: 16),
                // Actions principales
                _AccountSection(
                  title: '',
                  children: [
                    _ActionRow(
                      items: [
                        _ActionItem(
                          icon: Icons.swap_horiz,
                          label: 'Mes trocs',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClientTradesScreen(),
                              ),
                            );
                          },
                        ),
                        _ActionItem(
                          icon: Icons.history,
                          label: 'Historique',
                          onTap: () {
                            // TODO: Naviguer vers historique
                          },
                        ),
                        _ActionItem(
                          icon: Icons.favorite_border,
                          label: 'Favoris',
                          onTap: () {
                            // TODO: Naviguer vers favoris
                          },
                        ),
                        _ActionItem(
                          icon: Icons.local_offer,
                          label: 'Coupons',
                          onTap: () {
                            // TODO: Naviguer vers coupons
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Parrainage (très important au Faso)
                _AccountSection(
                  title: 'Parrainage',
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.card_giftcard,
                                color: AppColors.warning,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mon code parrainage',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    if (user.referralCode != null)
                                      Text(
                                        user.referralCode!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () async {
                                  if (user.referralCode != null) {
                                    await Clipboard.setData(
                                      ClipboardData(text: user.referralCode!),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Code copié !'),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Parrainez vos amis et gagnez des avantages !',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Services
                _AccountSection(
                  title: 'Services',
                  children: [
                    _ServiceTile(
                      icon: Icons.account_balance_wallet,
                      title: 'Portefeuille',
                      subtitle: 'Solde et paiements',
                      onTap: () {
                        // TODO: Naviguer vers portefeuille
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.card_giftcard,
                      title: 'Bonus',
                      subtitle: 'Crédits et récompenses',
                      onTap: () {
                        // TODO: Naviguer vers bonus
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.shopping_bag,
                      title: 'Crédits shopping',
                      subtitle: 'Voir mes crédits',
                      onTap: () {
                        // TODO: Naviguer vers crédits
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.headset_mic,
                      title: 'Centre d\'aide',
                      subtitle: 'Support client',
                      onTap: () {
                        // TODO: Naviguer vers aide
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.feedback,
                      title: 'Suggestion',
                      subtitle: 'Partagez vos idées',
                      onTap: () {
                        // TODO: Naviguer vers suggestions
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Informations
                _AccountSection(
                  title: 'Informations',
                  children: [
                    _InfoTile(
                      icon: Icons.location_on,
                      title: 'Adresses',
                      subtitle: 'Gérer mes adresses de livraison',
                      onTap: () {
                        // TODO: Naviguer vers adresses
                      },
                    ),
                    _InfoTile(
                      icon: Icons.phone,
                      title: 'Téléphone',
                      subtitle: user.phone,
                      onTap: () {
                        // TODO: Modifier téléphone
                      },
                    ),
                    _InfoTile(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: user.email,
                      onTap: () {
                        // TODO: Modifier email
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// Compte vendeur
  Widget _buildSellerAccount(BuildContext context, User user, bool isWholesaler) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Mon compte',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.onPrimary,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Vendeur',
                                    style: TextStyle(
                                      color: AppColors.onPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isWholesaler) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Grossiste',
                                      style: TextStyle(
                                        color: AppColors.onPrimary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: AppColors.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu vendeur
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Accès rapide dashboard
                _AccountSection(
                  title: 'Dashboard',
                  children: [
                    _ServiceTile(
                      icon: Icons.dashboard,
                      title: 'Tableau de bord',
                      subtitle: 'Voir mes statistiques et ventes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellerDashboardScreen(),
                          ),
                        );
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.inventory_2,
                      title: 'Mes produits',
                      subtitle: 'Gérer mes produits',
                      onTap: () {
                        // Navigation gérée par la navigation vendeur
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.shopping_bag,
                      title: 'Mes ventes',
                      subtitle: 'Suivre mes commandes',
                      onTap: () {
                        // Navigation gérée par la navigation vendeur
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.swap_horiz,
                      title: 'Propositions de troc',
                      subtitle: 'Gérer les propositions reçues',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellerTradesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Informations entreprise
                _AccountSection(
                  title: 'Entreprise',
                  children: [
                    _ServiceTile(
                      icon: Icons.business,
                      title: 'Informations entreprise',
                      subtitle: 'Présentation, coordonnées, CGV',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellerCompanyInfoScreen(),
                          ),
                        );
                      },
                    ),
                    if (isWholesaler)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: user.isWholesalerApproved
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: user.isWholesalerApproved
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              user.isWholesalerApproved
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color: user.isWholesalerApproved
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                user.isWholesalerApproved
                                    ? 'Compte grossiste approuvé'
                                    : 'En attente d\'approbation admin',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Parrainage
                _AccountSection(
                  title: 'Parrainage',
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.card_giftcard,
                                color: AppColors.warning,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mon code parrainage',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    if (user.referralCode != null)
                                      Text(
                                        user.referralCode!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () async {
                                  if (user.referralCode != null) {
                                    await Clipboard.setData(
                                      ClipboardData(text: user.referralCode!),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Code copié !'),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Informations personnelles
                _AccountSection(
                  title: 'Informations',
                  children: [
                    _InfoTile(
                      icon: Icons.phone,
                      title: 'Téléphone',
                      subtitle: user.phone,
                      onTap: () {
                        // TODO: Modifier téléphone
                      },
                    ),
                    _InfoTile(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: user.email,
                      onTap: () {
                        // TODO: Modifier email
                      },
                    ),
                    _InfoTile(
                      icon: Icons.location_on,
                      title: 'Ville',
                      subtitle: user.city,
                      onTap: () {
                        // TODO: Modifier ville
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// Compte admin
  Widget _buildAdminAccount(BuildContext context, User user) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: AppColors.error,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Compte Admin',
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.error,
                      AppColors.error.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.onPrimary,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Administrateur ECONOMAX',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: AppColors.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu admin
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Dashboard admin
                _AccountSection(
                  title: 'Administration',
                  children: [
                    _ServiceTile(
                      icon: Icons.dashboard,
                      title: 'Tableau de bord',
                      subtitle: 'Vue d\'ensemble de la plateforme',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminDashboardScreen(),
                          ),
                        );
                      },
                    ),
                    _ServiceTile(
                      icon: Icons.store,
                      title: 'Gestion vendeurs',
                      subtitle: 'Approuver, marquer, bloquer',
                      onTap: () {
                        // Navigation gérée par la navigation admin
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Informations
                _AccountSection(
                  title: 'Informations',
                  children: [
                    _InfoTile(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: user.email,
                      onTap: () {
                        // TODO: Modifier email
                      },
                    ),
                    _InfoTile(
                      icon: Icons.phone,
                      title: 'Téléphone',
                      subtitle: user.phone,
                      onTap: () {
                        // TODO: Modifier téléphone
                      },
                    ),
                    _InfoTile(
                      icon: Icons.location_on,
                      title: 'Ville',
                      subtitle: user.city,
                      onTap: () {
                        // TODO: Modifier ville
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section de compte
class _AccountSection extends StatelessWidget {
  const _AccountSection({
    required this.title,
    required this.children,
    this.actionText,
    this.onActionTap,
  });

  final String title;
  final List<Widget> children;
  final String? actionText;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty || actionText != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title.isNotEmpty)
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  if (actionText != null)
                    TextButton(
                      onPressed: onActionTap,
                      child: Text(
                        actionText!,
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                ],
              ),
            if (title.isNotEmpty && children.isNotEmpty)
              const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Ligne de statuts de commande
class _OrderStatusRow extends StatelessWidget {
  const _OrderStatusRow({required this.items});

  final List<_OrderStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.map((item) => Expanded(
            child: _OrderStatusItemWidget(item: item),
          )).toList(),
    );
  }
}

/// Item de statut de commande
class _OrderStatusItem {
  const _OrderStatusItem({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;
}

class _OrderStatusItemWidget extends StatelessWidget {
  const _OrderStatusItemWidget({required this.item});

  final _OrderStatusItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderListScreen(),
                          ),
                        );
                      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              if (item.count > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${item.count}',
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Ligne d'actions
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.items});

  final List<_ActionItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.map((item) => Expanded(
            child: _ActionItemWidget(item: item),
          )).toList(),
    );
  }
}

/// Item d'action
class _ActionItem {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _ActionItemWidget extends StatelessWidget {
  const _ActionItemWidget({required this.item});

  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Tuile de service
class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

/// Tuile d'information
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

