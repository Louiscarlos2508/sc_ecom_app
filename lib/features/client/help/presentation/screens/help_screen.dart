import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:economax/shared/core/theme/app_colors.dart';

/// Écran du centre d'aide
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Centre d\'aide'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HelpSection(
            title: 'Questions fréquentes',
            items: [
              _HelpItem(
                icon: Icons.shopping_cart,
                title: 'Comment passer une commande ?',
                subtitle: 'Guide pour commander sur ECONOMAX',
                onTap: () {
                  _showHelpDialog(
                    context,
                    'Comment passer une commande ?',
                    '1. Parcourez les produits disponibles\n'
                    '2. Ajoutez les produits au panier\n'
                    '3. Allez dans votre panier et validez\n'
                    '4. Choisissez votre méthode de paiement\n'
                    '5. Confirmez votre commande',
                  );
                },
              ),
              _HelpItem(
                icon: Icons.payment,
                title: 'Modes de paiement',
                subtitle: 'Orange Money, Moov Money, Wave, Crypto',
                onTap: () {
                  _showHelpDialog(
                    context,
                    'Modes de paiement',
                    'ECONOMAX accepte plusieurs modes de paiement :\n\n'
                    '• Mobile Money : Orange Money, Moov Money, Wave, Telecel Money\n'
                    '• Cryptomonnaies : Bitcoin (BTC), USDT, Ethereum (ETH)\n\n'
                    'Tous les paiements sont sécurisés.',
                  );
                },
              ),
              _HelpItem(
                icon: Icons.local_shipping,
                title: 'Livraison',
                subtitle: 'Frais et délais de livraison',
                onTap: () {
                  _showHelpDialog(
                    context,
                    'Livraison',
                    '• Livraison disponible dans toutes les villes du Burkina Faso\n'
                    '• Frais de livraison calculés selon la distance\n'
                    '• Délai moyen : 2-5 jours ouvrables\n'
                    '• Suivez votre commande dans "Mes commandes"',
                  );
                },
              ),
              _HelpItem(
                icon: Icons.swap_horiz,
                title: 'Système de troc',
                subtitle: 'Comment échanger des produits',
                onTap: () {
                  _showHelpDialog(
                    context,
                    'Système de troc',
                    'Le troc permet d\'échanger vos produits avec d\'autres utilisateurs :\n\n'
                    '1. Consultez un produit avec l\'icône de troc\n'
                    '2. Proposez un produit en échange\n'
                    '3. Le vendeur accepte ou refuse votre proposition\n'
                    '4. Organisez l\'échange une fois accepté',
                  );
                },
              ),
              _HelpItem(
                icon: Icons.assignment_return,
                title: 'Retours et remboursements',
                subtitle: 'Politique de retour',
                onTap: () {
                  _showHelpDialog(
                    context,
                    'Retours et remboursements',
                    '• Délai de retour : 7 jours après réception\n'
                    '• Produit doit être dans son état d\'origine\n'
                    '• Contactez le support pour initier un retour\n'
                    '• Remboursement sous 5-10 jours ouvrables',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _HelpSection(
            title: 'Contact',
            items: [
              _HelpItem(
                icon: Icons.phone,
                title: 'Téléphone',
                subtitle: '+226 XX XX XX XX',
                onTap: () {
                  _launchUrl('tel:+226XXXXXXXX');
                },
              ),
              _HelpItem(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'support@economax.bf',
                onTap: () {
                  _launchUrl('mailto:support@economax.bf');
                },
              ),
              _HelpItem(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: 'Chat avec le support',
                onTap: () {
                  _launchUrl('https://wa.me/226XXXXXXXX');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _HelpSection(
            title: 'Informations',
            items: [
              _HelpItem(
                icon: Icons.info,
                title: 'À propos de ECONOMAX',
                subtitle: 'Notre histoire et mission',
                onTap: () {
                  _showHelpDialog(
                    context,
                    'À propos de ECONOMAX',
                    'ECONOMAX est la première plateforme e-commerce 100% burkinabè.\n\n'
                    'Notre mission :\n'
                    '• Rendre le commerce en ligne accessible à tous\n'
                    '• Soutenir les commerçants locaux\n'
                    '• Promouvoir les produits du Burkina Faso\n'
                    '• Faciliter les échanges entre Burkinabè',
                  );
                },
              ),
              _HelpItem(
                icon: Icons.security,
                title: 'Sécurité et confidentialité',
                subtitle: 'Protection de vos données',
                onTap: () {
                  _showHelpDialog(
                    context,
                    'Sécurité et confidentialité',
                    'Votre sécurité est notre priorité :\n\n'
                    '• Données cryptées et sécurisées\n'
                    '• Paiements sécurisés\n'
                    '• Aucune donnée partagée avec des tiers\n'
                    '• Conformité RGPD',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

/// Section d'aide
class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_HelpItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _HelpItemWidget(item: item)),
      ],
    );
  }
}

/// Item d'aide
class _HelpItem {
  const _HelpItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

/// Widget d'item d'aide
class _HelpItemWidget extends StatelessWidget {
  const _HelpItemWidget({required this.item});

  final _HelpItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(item.icon, color: AppColors.primary),
        title: Text(item.title),
        subtitle: Text(item.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: item.onTap,
      ),
    );
  }
}

