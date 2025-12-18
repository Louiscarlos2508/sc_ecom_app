import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/utils/price_formatter.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import 'package:economax/features/client/cart/presentation/providers/cart_provider.dart';
import 'package:economax/features/client/orders/presentation/providers/order_provider.dart';
import 'crypto_logo.dart';

/// Écran de confirmation avec adresse crypto
class CryptoPaymentConfirmationScreen extends ConsumerWidget {
  const CryptoPaymentConfirmationScreen({
    super.key,
    required this.transactionHash,
    required this.currency,
    required this.amount,
    required this.amountFcfa,
    required this.walletAddress,
  });

  final String transactionHash;
  final String currency;
  final double amount;
  final int amountFcfa;
  final String walletAddress;

  Future<void> _createOrder(WidgetRef ref, BuildContext context) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final cart = ref.read(cartProvider);
    final selectedItems = cart.values.where((item) => item.selected).toList();
    if (selectedItems.isEmpty) return;

    final cartNotifier = ref.read(cartProvider.notifier);
    final deliveryFee = cartNotifier.calculateDeliveryFee(user.city);

    try {
      final orderId = await ref.read(orderProvider.notifier).createOrderFromCart(
            userId: user.id,
            deliveryCity: user.city,
            deliveryAddress: null,
            notes: null,
            deliveryFee: deliveryFee,
          );

      // Marquer la commande comme payée
      ref.read(orderProvider.notifier).markOrderAsPaid(
            orderId,
            currency,
            transactionHash,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création de la commande: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copié dans le presse-papiers'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Créer la commande automatiquement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createOrder(ref, context);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Paiement Crypto'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  CryptoLogo(
                    currency: currency,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Envoyez exactement',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${amount.toStringAsFixed(currency == 'BTC' ? 8 : 6)} $currency',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    PriceFormatter.format(amountFcfa),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Adresse du portefeuille
            Text(
              'Adresse du portefeuille',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      walletAddress,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    color: AppColors.primary,
                    onPressed: () => _copyToClipboard(context, walletAddress),
                    tooltip: 'Copier',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // QR Code placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 120,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scannez pour payer',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ID de transaction
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID de transaction',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          transactionHash,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        color: AppColors.primary,
                        onPressed: () =>
                            _copyToClipboard(context, transactionHash),
                        tooltip: 'Copier',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Avertissement
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.error.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Une fois la transaction confirmée sur la blockchain, votre commande sera automatiquement validée. Cela peut prendre de 10 minutes à 1 heure.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.textSecondary),
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Retour'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Ouvrir l'app de portefeuille crypto
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Ouvrir l\'application de portefeuille'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Ouvrir le portefeuille'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

