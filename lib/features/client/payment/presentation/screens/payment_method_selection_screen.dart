import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/models/payment_method.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/shared/core/utils/price_formatter.dart';
import '../widgets/payment_method_logo.dart';
import 'mobile_money_payment_screen.dart';
import 'crypto_payment_screen.dart';

/// Écran de sélection de méthode de paiement
class PaymentMethodSelectionScreen extends ConsumerWidget {
  const PaymentMethodSelectionScreen({
    super.key,
    required this.totalAmount,
  });

  final int totalAmount; // Montant total en FCFA

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethods = _getAvailablePaymentMethods();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Méthode de paiement'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // En-tête avec montant total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              children: [
                Text(
                  'Montant à payer',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  PriceFormatter.format(totalAmount),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          // Liste des méthodes de paiement
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Section Mobile Money
                _PaymentSection(
                  title: 'Mobile Money',
                  icon: Icons.phone_android,
                  children: paymentMethods
                      .where((m) => [
                            PaymentMethodType.orangeMoney,
                            PaymentMethodType.moovMoney,
                            PaymentMethodType.wave,
                            PaymentMethodType.telecelMoney,
                          ].contains(m.type))
                      .map((method) => _PaymentMethodCard(
                            method: method,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MobileMoneyPaymentScreen(
                                    method: method,
                                    amount: totalAmount,
                                  ),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                // Section Crypto
                _PaymentSection(
                  title: 'Cryptomonnaie',
                  icon: Icons.currency_bitcoin,
                  children: paymentMethods
                      .where((m) => m.type == PaymentMethodType.crypto)
                      .map((method) => _PaymentMethodCard(
                            method: method,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CryptoPaymentScreen(
                                    amount: totalAmount,
                                  ),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PaymentMethod> _getAvailablePaymentMethods() {
    return [
      PaymentMethod(
        type: PaymentMethodType.orangeMoney,
        name: 'Orange Money',
        icon: Icons.money,
        description: 'Payer avec votre compte Orange Money',
      ),
      PaymentMethod(
        type: PaymentMethodType.moovMoney,
        name: 'Moov Money',
        icon: Icons.money,
        description: 'Payer avec votre compte Moov Money',
      ),
      PaymentMethod(
        type: PaymentMethodType.wave,
        name: 'Wave',
        icon: Icons.account_balance_wallet,
        description: 'Payer avec Wave',
      ),
      PaymentMethod(
        type: PaymentMethodType.telecelMoney,
        name: 'Telecel Money',
        icon: Icons.money,
        description: 'Payer avec Telecel Money',
      ),
      PaymentMethod(
        type: PaymentMethodType.crypto,
        name: 'Cryptomonnaie',
        icon: Icons.currency_bitcoin,
        description: 'Payer avec BTC, USDT ou ETH',
      ),
    ];
  }
}

/// Section de paiement
class _PaymentSection extends StatelessWidget {
  const _PaymentSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

/// Carte de méthode de paiement
class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.onTap,
  });

  final PaymentMethod method;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: method.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              PaymentMethodLogo(
                type: method.type,
                size: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

