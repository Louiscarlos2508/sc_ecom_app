import 'package:flutter/material.dart';

/// Méthodes de paiement disponibles dans ECONOMAX
enum PaymentMethodType {
  orangeMoney,
  moovMoney,
  wave,
  telecelMoney,
  crypto,
}

/// Modèle pour une méthode de paiement
class PaymentMethod {
  const PaymentMethod({
    required this.type,
    required this.name,
    required this.icon,
    required this.description,
    this.isAvailable = true,
  });

  final PaymentMethodType type;
  final String name;
  final IconData icon;
  final String description;
  final bool isAvailable;
}

/// Modèle pour un paiement Mobile Money
class MobileMoneyPayment {
  const MobileMoneyPayment({
    required this.type,
    required this.phoneNumber,
    required this.amount,
    required this.transactionId,
    this.status = PaymentStatus.pending,
    this.createdAt,
  });

  final PaymentMethodType type;
  final String phoneNumber;
  final int amount; // En FCFA
  final String transactionId;
  final PaymentStatus status;
  final DateTime? createdAt;

  factory MobileMoneyPayment.fromJson(Map<String, dynamic> json) {
    return MobileMoneyPayment(
      type: PaymentMethodType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => PaymentMethodType.orangeMoney,
      ),
      phoneNumber: json['phoneNumber'] as String,
      amount: json['amount'] as int,
      transactionId: json['transactionId'] as String,
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'phoneNumber': phoneNumber,
      'amount': amount,
      'transactionId': transactionId,
      'status': status.toString(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

/// Modèle pour un paiement crypto
class CryptoPayment {
  const CryptoPayment({
    required this.currency,
    required this.walletAddress,
    required this.amount,
    required this.amountFcfa,
    required this.transactionHash,
    this.status = PaymentStatus.pending,
    this.createdAt,
  });

  final String currency; // BTC, USDT, etc.
  final String walletAddress;
  final double amount; // Montant en crypto
  final int amountFcfa; // Montant équivalent en FCFA
  final String transactionHash;
  final PaymentStatus status;
  final DateTime? createdAt;

  factory CryptoPayment.fromJson(Map<String, dynamic> json) {
    return CryptoPayment(
      currency: json['currency'] as String,
      walletAddress: json['walletAddress'] as String,
      amount: (json['amount'] as num).toDouble(),
      amountFcfa: json['amountFcfa'] as int,
      transactionHash: json['transactionHash'] as String,
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => PaymentStatus.pending,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'walletAddress': walletAddress,
      'amount': amount,
      'amountFcfa': amountFcfa,
      'transactionHash': transactionHash,
      'status': status.toString(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

/// Statut d'un paiement
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

