import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier pour la catégorie sélectionnée (API Riverpod 3.x)
class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setCategory(String? category) {
    state = category;
  }
}

/// Provider pour la catégorie sélectionnée
final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
  () => SelectedCategoryNotifier(),
);

/// Liste des catégories disponibles
final categoriesProvider = Provider<List<String>>((ref) {
  return [
    'Tout',
    'PROMOTIONS',
    'Femmes',
    'Hommes',
    'Électronique',
    'Maison & Jardin',
    'Mode',
    'Nouveautés',
  ];
});

