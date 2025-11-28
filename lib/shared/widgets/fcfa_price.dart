import 'package:flutter/material.dart';
import '../utils/price_formatter.dart';

/// Widget pour afficher un prix en FCFA
/// Format: 1 500 FCFA
class FcfaPrice extends StatelessWidget {
  const FcfaPrice({
    super.key,
    required this.price,
    this.style,
  });

  final int price;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      PriceFormatter.format(price),
      style: style ?? Theme.of(context).textTheme.bodyLarge,
    );
  }
}

