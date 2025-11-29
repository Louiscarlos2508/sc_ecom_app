import '../../../../shared/models/product.dart';

/// Utilitaires pour le filtrage des produits par catégorie
class ProductFilterUtils {
  ProductFilterUtils._();

  /// Filtrer les produits par catégorie (amélioré)
  static List<Product> filterProductsByCategory(
    List<Product> products,
    String category,
  ) {
    if (category == 'Tout' || category.isEmpty) {
      return products;
    }

    switch (category) {
      case 'PROMOTIONS':
        return products.where((p) {
          final index = products.indexOf(p);
          return index % 2 == 0;
        }).toList();

      case 'Femmes':
      case 'Hommes':
      case 'Mode':
        return products.where((p) {
          final name = p.name.toLowerCase();
          final desc = p.description.toLowerCase();
          return name.contains('mode') ||
              name.contains('vêtement') ||
              name.contains('chaussure') ||
              name.contains('habillement') ||
              desc.contains('mode') ||
              desc.contains('vêtement');
        }).toList();

      case 'Électronique':
        return products.where((p) {
          final name = p.name.toLowerCase();
          final desc = p.description.toLowerCase();
          return name.contains('téléphone') ||
              name.contains('télévision') ||
              name.contains('android') ||
              name.contains('led') ||
              name.contains('smartphone') ||
              name.contains('tv') ||
              desc.contains('électronique') ||
              desc.contains('téléphone');
        }).toList();

      case 'Maison & Jardin':
        return products.where((p) {
          final name = p.name.toLowerCase();
          final desc = p.description.toLowerCase();
          return name.contains('riz') ||
              name.contains('maïs') ||
              name.contains('arachide') ||
              name.contains('aliment') ||
              desc.contains('alimentaire') ||
              desc.contains('maison');
        }).toList();

      case 'Nouveautés':
        return products.take(3).toList();

      default:
        return products.where((p) {
          final name = p.name.toLowerCase();
          final desc = p.description.toLowerCase();
          final categoryLower = category.toLowerCase();
          return name.contains(categoryLower) || desc.contains(categoryLower);
        }).toList();
    }
  }
}

