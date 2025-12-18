import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier pour l'index de navigation vendeur
class SellerNavigationIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

/// Provider pour l'index de navigation vendeur
final sellerNavigationIndexProvider =
    NotifierProvider<SellerNavigationIndexNotifier, int>(
  () => SellerNavigationIndexNotifier(),
);

