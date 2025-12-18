import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import 'package:economax/features/auth/presentation/screens/login_screen.dart';
import 'package:economax/shared/features/troc/presentation/screens/my_trade_products_screen.dart';

/// Écran de paramètres (inspiré Alibaba)
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _handleLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(currentUserProvider.notifier).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Compte
          _SettingsSection(
            title: 'Compte',
            items: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Modifier le profil',
                subtitle: 'Nom, email, téléphone',
                onTap: () {
                  // TODO: Naviguer vers édition profil
                },
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Changer le mot de passe',
                onTap: () {
                  // TODO: Naviguer vers changement mot de passe
                },
              ),
              _SettingsTile(
                icon: Icons.location_on_outlined,
                title: 'Adresses de livraison',
                subtitle: 'Gérer vos adresses',
                onTap: () {
                  // TODO: Naviguer vers adresses
                },
              ),
              _SettingsTile(
                icon: Icons.swap_horiz,
                title: 'Mes produits de troc',
                subtitle: 'Gérer vos produits téléversés pour le troc',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyTradeProductsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Notifications
          _SettingsSection(
            title: 'Notifications',
            items: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications push',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Gérer notifications
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.email_outlined,
                title: 'Notifications email',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Gérer notifications email
                  },
                  activeColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Apparence
          _SettingsSection(
            title: 'Apparence',
            items: [
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Mode sombre',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // TODO: Gérer thème sombre
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              _SettingsTile(
                icon: Icons.language,
                title: 'Langue',
                subtitle: 'Français',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                onTap: () {
                  // TODO: Changer langue
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Aide & Support
          _SettingsSection(
            title: 'Aide & Support',
            items: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Centre d\'aide',
                onTap: () {
                  // TODO: Naviguer vers aide
                },
              ),
              _SettingsTile(
                icon: Icons.chat_bubble_outline,
                title: 'Nous contacter',
                onTap: () {
                  // TODO: Ouvrir chat support
                },
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'À propos de ECONOMAX',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'ECONOMAX',
                    applicationVersion: '1.0.0',
                    applicationIcon: Icon(
                      Icons.shopping_cart,
                      color: AppColors.primary,
                      size: 48,
                    ),
                    children: [
                      const Text('E-commerce 100% burkinabè'),
                      const Text('Ouagadougou, Bobo, Koudougou & partout'),
                      const SizedBox(height: 16),
                      const Text(
                        'Développé par Carlos Simpore',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('Scalario'),
                    ],
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Déconnexion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => _handleLogout(context, ref),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error),
                  foregroundColor: AppColors.error,
                ),
                child: const Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// Section de paramètres
class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          color: AppColors.surface,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

/// Tuile de paramètre
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                )
              : null),
      onTap: onTap,
    );
  }
}

