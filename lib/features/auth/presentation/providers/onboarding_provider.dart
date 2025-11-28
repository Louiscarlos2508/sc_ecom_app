import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier pour la page courante de l'onboarding
class OnboardingCurrentPageNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int page) {
    state = page;
  }
}

/// Provider pour la page courante
final onboardingCurrentPageProvider =
    NotifierProvider<OnboardingCurrentPageNotifier, int>(
  () => OnboardingCurrentPageNotifier(),
);

/// Provider pour le PageController
final onboardingPageControllerProvider = Provider<PageController>((ref) {
  final controller = PageController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

