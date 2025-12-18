import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/models/payment_method.dart';

/// Notifier pour gérer les paiements
class PaymentNotifier extends Notifier<List<dynamic>> {
  @override
  List<dynamic> build() => [];

  /// Créer un paiement Mobile Money
  String createMobileMoneyPayment({
    required PaymentMethodType type,
    required String phoneNumber,
    required int amount,
  }) {
    final transactionId =
        'MM_${DateTime.now().millisecondsSinceEpoch}_${phoneNumber.substring(phoneNumber.length - 4)}';

    final payment = MobileMoneyPayment(
      type: type,
      phoneNumber: phoneNumber,
      amount: amount,
      transactionId: transactionId,
      createdAt: DateTime.now(),
    );

    // TODO: Envoyer à l'API backend
    return transactionId;
  }

  /// Créer un paiement crypto
  String createCryptoPayment({
    required String currency,
    required String walletAddress,
    required double amount,
    required int amountFcfa,
  }) {
    final transactionHash =
        '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';

    final payment = CryptoPayment(
      currency: currency,
      walletAddress: walletAddress,
      amount: amount,
      amountFcfa: amountFcfa,
      transactionHash: transactionHash,
      createdAt: DateTime.now(),
    );

    // TODO: Envoyer à l'API backend
    return transactionHash;
  }

  /// Vérifier le statut d'un paiement
  PaymentStatus checkPaymentStatus(String transactionId) {
    // TODO: Vérifier le statut depuis l'API
    return PaymentStatus.pending;
  }
}

/// Provider pour les paiements
final paymentProvider = NotifierProvider<PaymentNotifier, List<dynamic>>(
  () => PaymentNotifier(),
);

/// Taux de change crypto (mock)
final cryptoRatesProvider = Provider<Map<String, double>>((ref) {
  return {
    'BTC': 25000000.0, // 1 BTC = 25 000 000 FCFA (exemple)
    'USDT': 625.0, // 1 USDT = 625 FCFA (exemple)
    'ETH': 1800000.0, // 1 ETH = 1 800 000 FCFA (exemple)
  };
});

