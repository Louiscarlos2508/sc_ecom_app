import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/payment_method.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/price_formatter.dart';
import '../providers/payment_provider.dart';
import '../widgets/crypto_payment_confirmation_screen.dart';
import '../widgets/crypto_logo.dart';

/// Écran de paiement crypto
class CryptoPaymentScreen extends ConsumerStatefulWidget {
  const CryptoPaymentScreen({
    super.key,
    required this.amount,
  });

  final int amount; // Montant en FCFA

  @override
  ConsumerState<CryptoPaymentScreen> createState() =>
      _CryptoPaymentScreenState();
}

class _CryptoPaymentScreenState extends ConsumerState<CryptoPaymentScreen> {
  String _selectedCrypto = 'USDT';
  bool _isProcessing = false;
  String? _walletAddress;

  final Map<String, String> _walletAddresses = {
    'BTC': 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
    'USDT': 'TXYZabcdefghijklmnopqrstuvwxyz123456789',
    'ETH': '0x1234567890abcdef1234567890abcdef12345678',
  };

  double _getCryptoAmount() {
    final rates = ref.watch(cryptoRatesProvider);
    final rate = rates[_selectedCrypto] ?? 1.0;
    return widget.amount / rate;
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
      _walletAddress = _walletAddresses[_selectedCrypto];
    });

    // Simuler le processus de paiement
    Future.delayed(const Duration(seconds: 2), () {
      final transactionHash = ref.read(paymentProvider.notifier)
          .createCryptoPayment(
        currency: _selectedCrypto,
        walletAddress: _walletAddress!,
        amount: _getCryptoAmount(),
        amountFcfa: widget.amount,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CryptoPaymentConfirmationScreen(
              transactionHash: transactionHash,
              currency: _selectedCrypto,
              amount: _getCryptoAmount(),
              amountFcfa: widget.amount,
              walletAddress: _walletAddress!,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rates = ref.watch(cryptoRatesProvider);
    final cryptoAmount = _getCryptoAmount();

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
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  CryptoLogo(
                    currency: 'USDT', // Logo par défaut
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Montant à payer',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    PriceFormatter.format(widget.amount),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Sélection de la cryptomonnaie
            Text(
              'Choisissez une cryptomonnaie',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...['USDT', 'BTC', 'ETH'].map((crypto) {
              final rate = rates[crypto] ?? 1.0;
              final amount = widget.amount / rate;
              final isSelected = _selectedCrypto == crypto;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCrypto = crypto;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CryptoLogo(
                          currency: crypto,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crypto,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${amount.toStringAsFixed(crypto == 'BTC' ? 8 : 6)} $crypto',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),
            // Montant équivalent
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Montant en $_selectedCrypto',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${cryptoAmount.toStringAsFixed(_selectedCrypto == 'BTC' ? 8 : 6)} $_selectedCrypto',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Montant en FCFA',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        PriceFormatter.format(widget.amount),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Informations de sécurité
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Important',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Veuillez vérifier l\'adresse du portefeuille avant d\'envoyer votre paiement. Les transactions crypto sont irréversibles.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Bouton de paiement
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                        ),
                      )
                    : Text(
                        'Générer l\'adresse de paiement',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

