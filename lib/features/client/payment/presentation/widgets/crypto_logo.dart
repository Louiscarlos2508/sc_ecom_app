import 'package:flutter/material.dart';
import 'package:economax/shared/core/theme/app_colors.dart';

/// Widget pour afficher le logo d'une cryptomonnaie
class CryptoLogo extends StatelessWidget {
  const CryptoLogo({
    super.key,
    required this.currency,
    this.size = 48,
  });

  final String currency; // BTC, USDT, ETH, etc.
  final double size;

  @override
  Widget build(BuildContext context) {
    switch (currency.toUpperCase()) {
      case 'BTC':
        return _BitcoinLogo(size: size);
      case 'USDT':
        return _USDTLogo(size: size);
      case 'ETH':
        return _EthereumLogo(size: size);
      default:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size * 0.2),
          ),
          child: Icon(
            Icons.currency_bitcoin,
            size: size * 0.6,
            color: AppColors.textSecondary,
          ),
        );
    }
  }
}

/// Logo Bitcoin (couleur officielle: Orange #F7931A)
class _BitcoinLogo extends StatelessWidget {
  const _BitcoinLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF7931A), // Orange Bitcoin officiel
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      child: Center(
        child: Text(
          '₿',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.55,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}

/// Logo USDT / Tether (couleur officielle: Vert #26A17B)
class _USDTLogo extends StatelessWidget {
  const _USDTLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF26A17B), // Vert USDT officiel
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      child: Center(
        child: Text(
          '₮',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}

/// Logo Ethereum (couleur officielle: Bleu/Violet #627EEA)
class _EthereumLogo extends StatelessWidget {
  const _EthereumLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF627EEA), // Bleu Ethereum
            Color(0xFF8B8BCA), // Violet Ethereum
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      child: Center(
        child: Text(
          'Ξ',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}

