import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:economax/shared/core/models/order.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/utils/price_formatter.dart';
import 'package:economax/shared/core/widgets/fcfa_price.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import '../providers/order_provider.dart';
import 'rate_order_screen.dart';
import 'delivery_code_screen.dart';

/// Écran de détails d'une commande
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  final Order order;

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'À payer';
      case OrderStatus.paid:
        return 'Payée';
      case OrderStatus.shipping:
        return 'À expédier';
      case OrderStatus.shipped:
        return 'Expédiée';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.cancelled:
        return 'Annulée';
      case OrderStatus.returned:
        return 'Retournée';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.paid:
      case OrderStatus.shipping:
        return AppColors.primary;
      case OrderStatus.shipped:
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isSeller = user?.isSeller ?? false;
    
    // Récupérer l'ordre depuis le provider pour avoir la version à jour avec deliveryCode
    final orders = ref.watch(orderProvider);
    final currentOrder = orders.firstWhere(
      (o) => o.id == order.id,
      orElse: () => order,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text('Commande #${currentOrder.id.length > 8 ? currentOrder.id.substring(0, 8) : currentOrder.id}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Statut de la commande
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(currentOrder.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(currentOrder.status),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _getStatusText(currentOrder.status),
                      style: TextStyle(
                        color: _getStatusColor(currentOrder.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    PriceFormatter.format(currentOrder.grandTotal),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Détails
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Produits
                  Text(
                    'Produits',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...currentOrder.items.map((item) => _OrderItemCard(item: item)),
                  const SizedBox(height: 24),
                  // Informations de livraison
                  _InfoSection(
                    title: 'Livraison',
                    children: [
                      if (currentOrder.deliveryCity != null)
                        _InfoRow(
                          label: 'Ville',
                          value: currentOrder.deliveryCity!,
                        ),
                      if (currentOrder.deliveryAddress != null)
                        _InfoRow(
                          label: 'Adresse',
                          value: currentOrder.deliveryAddress!,
                        ),
                      _InfoRow(
                        label: 'Frais de livraison',
                        value: PriceFormatter.format(currentOrder.deliveryFee),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Informations de paiement
                  if (currentOrder.paymentMethod != null)
                    _InfoSection(
                      title: 'Paiement',
                      children: [
                        _InfoRow(
                          label: 'Méthode',
                          value: currentOrder.paymentMethod!,
                        ),
                        if (currentOrder.paymentTransactionId != null)
                          _InfoRow(
                            label: 'Transaction',
                            value: currentOrder.paymentTransactionId!,
                          ),
                        if (currentOrder.paidAt != null)
                          _InfoRow(
                            label: 'Date de paiement',
                            value: '${currentOrder.paidAt!.day}/${currentOrder.paidAt!.month}/${currentOrder.paidAt!.year}',
                          ),
                      ],
                    ),
                  if (currentOrder.paymentMethod != null) const SizedBox(height: 16),
                  // Dates importantes
                  _InfoSection(
                    title: 'Dates',
                    children: [
                      _InfoRow(
                        label: 'Date de commande',
                        value: '${currentOrder.createdAt.day}/${currentOrder.createdAt.month}/${currentOrder.createdAt.year}',
                      ),
                      if (currentOrder.shippedAt != null)
                        _InfoRow(
                          label: 'Date d\'expédition',
                          value: '${currentOrder.shippedAt!.day}/${currentOrder.shippedAt!.month}/${currentOrder.shippedAt!.year}',
                        ),
                      if (currentOrder.deliveredAt != null)
                        _InfoRow(
                          label: 'Date de livraison',
                          value: '${currentOrder.deliveredAt!.day}/${currentOrder.deliveredAt!.month}/${currentOrder.deliveredAt!.year}',
                        ),
                    ],
                  ),
                  if (currentOrder.notes != null) ...[
                    const SizedBox(height: 16),
                    _InfoSection(
                      title: 'Notes',
                      children: [
                        Text(
                          currentOrder.notes!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                  // Code de livraison (si expédiée)
                  if (currentOrder.status == OrderStatus.shipped &&
                      currentOrder.deliveryCode != null) ...[
                    const SizedBox(height: 16),
                    _InfoSection(
                      title: 'Code de livraison',
                      children: [
                        // QR Code directement visible
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Présentez ce QR code au livreur',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              // QR Code
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: QrImageView(
                                  data: currentOrder.deliveryCode!,
                                  version: QrVersions.auto,
                                  size: 200,
                                  backgroundColor: Colors.white,
                                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Code textuel
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primary,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentOrder.deliveryCode!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            letterSpacing: 2,
                                          ),
                                    ),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      color: AppColors.primary,
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: currentOrder.deliveryCode!),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Code copié'),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                      },
                                      tooltip: 'Copier le code',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Bouton pour voir en plein écran
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DeliveryCodeScreen(
                                        order: order,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.fullscreen),
                                label: const Text('Voir en plein écran'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: BorderSide(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.warning.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.warning,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Le livreur scannera ce code QR pour vérifier votre identité avant de vous remettre la commande. Ne partagez jamais ce code avec quelqu\'un d\'autre.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Évaluation
                  if (currentOrder.rating != null) ...[
                    const SizedBox(height: 16),
                    _InfoSection(
                      title: 'Votre évaluation',
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              color: index < currentOrder.rating!
                                  ? AppColors.warning
                                  : AppColors.textSecondary.withOpacity(0.3),
                              size: 24,
                            ),
                          ),
                        ),
                        if (currentOrder.ratingComment != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            currentOrder.ratingComment!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(context, ref, user, isSeller, currentOrder),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    user,
    bool isSeller,
    Order currentOrder,
  ) {
    if (isSeller) {
      // Actions pour vendeur
      if (currentOrder.status == OrderStatus.paid) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(orderProvider.notifier).markOrderAsShipped(currentOrder.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Commande marquée comme expédiée'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text(
                  'Marquer comme expédiée',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    } else {
      // Actions pour client
      // Le client ne peut pas marquer comme reçu - seul le livreur le fait après scan du QR code
      if (currentOrder.canBeRated) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RateOrderScreen(order: order),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: const Text(
                  'Noter la commande',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }
  }
}

/// Carte d'un item de commande
class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: AppColors.secondary,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantité: ${item.quantity}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  FcfaPrice(
                    price: item.subtotal,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section d'information
class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Ligne d'information
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

