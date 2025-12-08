import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/price_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../order/presentation/providers/order_provider.dart';

/// Écran de confirmation de paiement Mobile Money
class PaymentConfirmationScreen extends ConsumerWidget {
  const PaymentConfirmationScreen({
    super.key,
    required this.transactionId,
    required this.method,
    required this.amount,
  });

  final String transactionId;
  final String method;
  final int amount;

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
            deliveryAddress: null, // TODO: Ajouter un champ d'adresse dans le profil
            notes: null,
            deliveryFee: deliveryFee,
          );

      // Marquer la commande comme payée
      ref.read(orderProvider.notifier).markOrderAsPaid(
            orderId,
            method,
            transactionId,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Créer la commande automatiquement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createOrder(ref, context);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Paiement initié',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Votre paiement de ${PriceFormatter.format(amount)} via $method a été initié.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'ID de transaction',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      transactionId,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

