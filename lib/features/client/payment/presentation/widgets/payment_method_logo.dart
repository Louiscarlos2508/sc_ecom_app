import 'package:flutter/material.dart';
import 'package:economax/shared/core/models/payment_method.dart';
import 'package:economax/shared/core/theme/app_colors.dart';

/// Widget pour afficher le logo d'une méthode de paiement
class PaymentMethodLogo extends StatelessWidget {
  const PaymentMethodLogo({
    super.key,
    required this.type,
    this.size = 48,
  });

  final PaymentMethodType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Pour Mobile Money, utiliser des logos officiels
    if (type == PaymentMethodType.orangeMoney) {
      return _OrangeMoneyLogo(size: size);
    } else if (type == PaymentMethodType.moovMoney) {
      return _MoovMoneyLogo(size: size);
    } else if (type == PaymentMethodType.wave) {
      return _WaveLogo(size: size);
    } else if (type == PaymentMethodType.telecelMoney) {
      return _TelecelMoneyLogo(size: size);
    } else if (type == PaymentMethodType.crypto) {
      return Icon(
        Icons.currency_bitcoin,
        size: size,
        color: AppColors.warning,
      );
    }

    return Icon(
      Icons.payment,
      size: size,
      color: AppColors.primary,
    );
  }
}

/// Logo Orange Money officiel
class _OrangeMoneyLogo extends StatelessWidget {
  const _OrangeMoneyLogo({required this.size});

  final double size;

  // URL du logo officiel Orange Money
  static const String logoUrl =
      'https://dimelo-answers-production.s3.eu-west-1.amazonaws.com/268/4d000a6e195a687e/om_logo_large.png?eec4b54';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.network(
          logoUrl,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si l'image ne charge pas
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6600), // Orange officiel
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: Text(
                  'OM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.5,
                  height: size * 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Logo Moov Money officiel
class _MoovMoneyLogo extends StatelessWidget {
  const _MoovMoneyLogo({required this.size});

  final double size;

  // URL du logo officiel Moov Africa
  static const String logoUrl =
      'https://upload.wikimedia.org/wikipedia/fr/1/1d/Moov_Africa_logo.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.network(
          logoUrl,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si l'image ne charge pas
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0066CC), // Bleu Moov
                    Color(0xFF00CC66), // Vert Moov
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFF0066CC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.5,
                  height: size * 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Logo Wave officiel
class _WaveLogo extends StatelessWidget {
  const _WaveLogo({required this.size});

  final double size;

  // URL du logo officiel Wave
  static const String logoUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMZvVlxdlT9GyRsplJDVoPU60qQh3BlUn95Q7g0QuBOH6YjJnZIVfJT5O0MiXGjNIawcw&usqp=CAU';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.network(
          logoUrl,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si l'image ne charge pas
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // Jaune Wave
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: Text(
                  'W',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.1),
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.5,
                  height: size * 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Logo Telecel Money officiel
class _TelecelMoneyLogo extends StatelessWidget {
  const _TelecelMoneyLogo({required this.size});

  final double size;

  // URL du logo officiel Telecel
  static const String logoUrl =
      'https://www.courrierconfidentiel.net/assets/images/Telecel.PNG';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2),
        child: Image.network(
          logoUrl,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si l'image ne charge pas
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFE60012), // Rouge Telecel
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: Text(
                  'T',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFE60012).withOpacity(0.1),
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.5,
                  height: size * 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

