import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/models/product_share.dart';

/// Écran de partage de produit sur réseaux sociaux
class ProductShareScreen extends StatelessWidget {
  const ProductShareScreen({
    super.key,
    required this.productId,
  });

  final String productId;

  Future<void> _shareToPlatform(
    BuildContext context,
    SharePlatform platform,
  ) async {
    // Générer un code unique pour ce partage
    final shareCode = '${productId}_${DateTime.now().millisecondsSinceEpoch}';
    final baseUrl = 'https://economax.bf';
    final shareUrl = '$baseUrl/product/$productId?ref=$shareCode';

    String message = '';
    switch (platform) {
      case SharePlatform.whatsapp:
      case SharePlatform.whatsappStatus:
        message =
            'Découvrez ce produit sur ECONOMAX 🇧🇫\n$shareUrl\n\nAchetez en toute confiance !';
        break;
      case SharePlatform.facebook:
        message =
            'Découvrez ce produit sur ECONOMAX 🇧🇫 - E-commerce 100% burkinabè\n$shareUrl';
        break;
      case SharePlatform.instagram:
        message = 'Découvrez ce produit sur ECONOMAX 🇧🇫\n$shareUrl';
        break;
      case SharePlatform.tiktok:
        message =
            'Découvrez ce produit sur ECONOMAX 🇧🇫\n$shareUrl\n#ECONOMAX #BurkinaFaso';
        break;
    }

    // Copier le lien dans le presse-papiers
    await Clipboard.setData(ClipboardData(text: shareUrl));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lien copié ! Partagez-le sur ${platform.name}',
          ),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'Ouvrir',
            textColor: AppColors.onPrimary,
            onPressed: () {
              // TODO: Ouvrir l'application correspondante
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Partager le produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Partagez ce produit sur vos réseaux sociaux',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Chaque lien partagé est unique et permet de suivre les ventes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),
            // Options de partage
            _ShareOption(
              icon: Icons.chat,
              label: 'WhatsApp',
              color: const Color(0xFF25D366),
              onTap: () => _shareToPlatform(context, SharePlatform.whatsapp),
            ),
            const SizedBox(height: 16),
            _ShareOption(
              icon: Icons.photo_camera,
              label: 'Statut WhatsApp',
              color: const Color(0xFF25D366),
              onTap: () =>
                  _shareToPlatform(context, SharePlatform.whatsappStatus),
            ),
            const SizedBox(height: 16),
            _ShareOption(
              icon: Icons.facebook,
              label: 'Facebook',
              color: const Color(0xFF1877F2),
              onTap: () => _shareToPlatform(context, SharePlatform.facebook),
            ),
            const SizedBox(height: 16),
            _ShareOption(
              icon: Icons.camera_alt,
              label: 'Instagram',
              color: const Color(0xFFE4405F),
              onTap: () => _shareToPlatform(context, SharePlatform.instagram),
            ),
            const SizedBox(height: 16),
            _ShareOption(
              icon: Icons.music_note,
              label: 'TikTok',
              color: Colors.black,
              onTap: () => _shareToPlatform(context, SharePlatform.tiktok),
            ),
            const SizedBox(height: 32),
            // Copier le lien
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final shareUrl =
                      'https://economax.bf/product/$productId?ref=${DateTime.now().millisecondsSinceEpoch}';
                  await Clipboard.setData(ClipboardData(text: shareUrl));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lien copié dans le presse-papiers !'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.link),
                label: const Text('Copier le lien'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Option de partage
class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
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
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

