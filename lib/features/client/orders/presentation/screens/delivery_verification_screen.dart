import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:economax/shared/core/models/order.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/utils/price_formatter.dart';
import 'package:economax/features/auth/presentation/providers/auth_provider.dart';
import '../providers/order_provider.dart';

/// Écran pour le livreur pour scanner et vérifier le code de livraison
class DeliveryVerificationScreen extends ConsumerStatefulWidget {
  const DeliveryVerificationScreen({super.key});

  @override
  ConsumerState<DeliveryVerificationScreen> createState() =>
      _DeliveryVerificationScreenState();
}

class _DeliveryVerificationScreenState
    extends ConsumerState<DeliveryVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isScanning = false;
  bool _isVerifying = false;
  Order? _foundOrder;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode(String code) {
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
      _foundOrder = null;
    });

    // Chercher la commande avec ce code
    final orders = ref.read(orderProvider);
    final order = orders.firstWhere(
      (o) => o.deliveryCode?.toUpperCase() == code.toUpperCase(),
      orElse: () => throw Exception('Commande non trouvée'),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _foundOrder = order;
        });
      }
    });
  }

  void _confirmDelivery() {
    if (_foundOrder == null) return;

    if (_foundOrder!.status != OrderStatus.shipped) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cette commande n\'est pas en statut "Expédiée". Statut actuel: ${_getStatusText(_foundOrder!.status)}',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Marquer comme livrée
    ref.read(orderProvider.notifier).markOrderAsDelivered(_foundOrder!.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Commande marquée comme livrée avec succès'),
          backgroundColor: AppColors.success,
        ),
      );

      // Réinitialiser
      setState(() {
        _foundOrder = null;
        _codeController.clear();
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isAdmin = user?.isAdmin ?? false;

    // Vérifier que l'utilisateur est admin ou livreur
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          title: const Text('Vérification livraison'),
        ),
        body: const Center(
          child: Text('Accès réservé aux administrateurs et livreurs'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Vérification livraison'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.primary,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Scanner le code de livraison',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scannez le QR code du client ou entrez le code manuellement pour vérifier l\'identité avant de remettre la commande.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Scanner QR Code
            if (!_isScanning)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isScanning = true;
                  });
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scanner QR Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            if (_isScanning) ...[
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          setState(() {
                            _isScanning = false;
                          });
                          _verifyCode(barcode.rawValue!);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isScanning = false;
                  });
                },
                child: const Text('Annuler le scan'),
              ),
            ],
            const SizedBox(height: 32),
            // Ou entrer manuellement
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Ou entrer le code manuellement',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'Ex: ECM-1234-ABCD',
                prefixIcon: const Icon(Icons.qr_code),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
              textCapitalization: TextCapitalization.characters,
              onSubmitted: _verifyCode,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isVerifying
                    ? null
                    : () => _verifyCode(_codeController.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                        ),
                      )
                    : const Text('Vérifier le code'),
              ),
            ),
            // Résultat de la vérification
            if (_foundOrder != null) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _foundOrder!.status == OrderStatus.shipped
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _foundOrder!.status == OrderStatus.shipped
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _foundOrder!.status == OrderStatus.shipped
                              ? Icons.check_circle
                              : Icons.warning,
                          color: _foundOrder!.status == OrderStatus.shipped
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _foundOrder!.status == OrderStatus.shipped
                                ? 'Commande trouvée et prête à être livrée'
                                : 'Commande trouvée mais statut incorrect',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'Numéro de commande',
                      value: _foundOrder!.id.length > 12
                          ? '${_foundOrder!.id.substring(0, 12)}...'
                          : _foundOrder!.id,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Client',
                      value: _foundOrder!.userId.length > 20
                          ? '${_foundOrder!.userId.substring(0, 20)}...'
                          : _foundOrder!.userId,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Statut',
                      value: _getStatusText(_foundOrder!.status),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Total',
                      value: PriceFormatter.format(_foundOrder!.grandTotal),
                    ),
                    if (_foundOrder!.deliveryCity != null) ...[
                      const SizedBox(height: 8),
                      _InfoRow(
                        label: 'Ville',
                        value: _foundOrder!.deliveryCity!,
                      ),
                    ],
                    if (_foundOrder!.status == OrderStatus.shipped) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _confirmDelivery,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: AppColors.onPrimary,
                          ),
                          child: const Text(
                            'Confirmer la livraison',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
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
    return Row(
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
    );
  }
}
