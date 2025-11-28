import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier pour l'index de navigation (API Riverpod 3.x)
class NavigationIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}

/// Provider pour l'index de navigation
final navigationIndexProvider =
    NotifierProvider<NavigationIndexNotifier, int>(
  () => NavigationIndexNotifier(),
);

