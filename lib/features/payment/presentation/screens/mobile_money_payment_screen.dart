import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/payment_method.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/price_formatter.dart';
import '../providers/payment_provider.dart';
import '../widgets/payment_confirmation_screen.dart';
import '../widgets/mobile_money_payment_header.dart';

/// Écran de paiement Mobile Money
class MobileMoneyPaymentScreen extends ConsumerStatefulWidget {
  const MobileMoneyPaymentScreen({
    super.key,
    required this.method,
    required this.amount,
  });

  final PaymentMethod method;
  final int amount;

  @override
  ConsumerState<MobileMoneyPaymentScreen> createState() =>
      _MobileMoneyPaymentScreenState();
}

class _MobileMoneyPaymentScreenState
    extends ConsumerState<MobileMoneyPaymentScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  String _getOperatorName() {
    switch (widget.method.type) {
      case PaymentMethodType.orangeMoney:
        return 'Orange Money';
      case PaymentMethodType.moovMoney:
        return 'Moov Money';
      case PaymentMethodType.wave:
        return 'Wave';
      case PaymentMethodType.telecelMoney:
        return 'Telecel Money';
      default:
        return 'Mobile Money';
    }
  }

  String _getPhonePrefix() {
    switch (widget.method.type) {
      case PaymentMethodType.orangeMoney:
        return '+226 76'; // Exemple pour Orange Money Burkina
      case PaymentMethodType.moovMoney:
        return '+226 70'; // Exemple pour Moov Money Burkina
      case PaymentMethodType.wave:
        return '+226 78'; // Exemple pour Wave
      case PaymentMethodType.telecelMoney:
        return '+226 72'; // Exemple pour Telecel
      default:
        return '+226';
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    // Simuler le processus de paiement
    Future.delayed(const Duration(seconds: 2), () {
      final transactionId = ref.read(paymentProvider.notifier)
          .createMobileMoneyPayment(
        type: widget.method.type,
        phoneNumber: _phoneController.text.trim(),
        amount: widget.amount,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentConfirmationScreen(
              transactionId: transactionId,
              method: _getOperatorName(),
              amount: widget.amount,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text('Paiement ${_getOperatorName()}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              MobileMoneyPaymentHeader(
                method: widget.method,
                amount: widget.amount,
              ),
              const SizedBox(height: 32),
              // Formulaire
              Text(
                'Numéro de téléphone',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Ex: ${_getPhonePrefix()} 00 00 00',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro';
                  }
                  if (value.length < 8) {
                    return 'Numéro invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Informations de sécurité
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Votre paiement est sécurisé et crypté',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
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
                          'Payer ${PriceFormatter.format(widget.amount)}',
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
      ),
    );
  }
}

