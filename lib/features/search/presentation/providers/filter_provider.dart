import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';

/// Modèle pour les filtres de recherche
class ProductFilters {
  const ProductFilters({
    this.minPrice,
    this.maxPrice,
    this.cities = const [],
    this.isWholesalerOnly = false,
    this.isSecondHandOnly = false,
    this.isTradableOnly = false,
    this.sortBy = SortBy.relevance,
  });

  final int? minPrice;
  final int? maxPrice;
  final List<String> cities;
  final bool isWholesalerOnly;
  final bool isSecondHandOnly;
  final bool isTradableOnly;
  final SortBy sortBy;

  ProductFilters copyWith({
    int? minPrice,
    int? maxPrice,
    List<String>? cities,
    bool? isWholesalerOnly,
    bool? isSecondHandOnly,
    bool? isTradableOnly,
    SortBy? sortBy,
  }) {
    return ProductFilters(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      cities: cities ?? this.cities,
      isWholesalerOnly: isWholesalerOnly ?? this.isWholesalerOnly,
      isSecondHandOnly: isSecondHandOnly ?? this.isSecondHandOnly,
      isTradableOnly: isTradableOnly ?? this.isTradableOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters {
    return minPrice != null ||
        maxPrice != null ||
        cities.isNotEmpty ||
        isWholesalerOnly ||
        isSecondHandOnly ||
        isTradableOnly ||
        sortBy != SortBy.relevance;
  }

  ProductFilters clear() {
    return const ProductFilters();
  }
}

/// Options de tri
enum SortBy {
  relevance, // Pertinence
  priceLowToHigh, // Prix croissant
  priceHighToLow, // Prix décroissant
  newest, // Plus récent
  mostSold, // Plus vendu
}

/// Notifier pour les filtres de produits
class ProductFiltersNotifier extends Notifier<ProductFilters> {
  @override
  ProductFilters build() => const ProductFilters();

  void setMinPrice(int? price) {
    state = state.copyWith(minPrice: price);
  }

  void setMaxPrice(int? price) {
    state = state.copyWith(maxPrice: price);
  }

  void toggleCity(String city) {
    final cities = List<String>.from(state.cities);
    if (cities.contains(city)) {
      cities.remove(city);
    } else {
      cities.add(city);
    }
    state = state.copyWith(cities: cities);
  }

  void setWholesalerOnly(bool value) {
    state = state.copyWith(isWholesalerOnly: value);
  }

  void setSecondHandOnly(bool value) {
    state = state.copyWith(isSecondHandOnly: value);
  }

  void setTradableOnly(bool value) {
    state = state.copyWith(isTradableOnly: value);
  }

  void setSortBy(SortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void clearFilters() {
    state = state.clear();
  }
}

/// Provider pour les filtres
final productFiltersProvider =
    NotifierProvider<ProductFiltersNotifier, ProductFilters>(
  () => ProductFiltersNotifier(),
);

/// Provider pour les produits filtrés
final filteredProductsProvider = Provider.family<List<Product>, List<Product>>(
  (ref, products) {
    final filters = ref.watch(productFiltersProvider);
    var filtered = List<Product>.from(products);

    // Filtrer par prix
    if (filters.minPrice != null) {
      filtered = filtered.where((p) => p.priceInFcfa >= filters.minPrice!).toList();
    }
    if (filters.maxPrice != null) {
      filtered = filtered.where((p) => p.priceInFcfa <= filters.maxPrice!).toList();
    }

    // Filtrer par ville
    if (filters.cities.isNotEmpty) {
      filtered = filtered.where((p) => filters.cities.contains(p.city)).toList();
    }

    // Filtrer par type de vendeur
    if (filters.isWholesalerOnly) {
      filtered = filtered.where((p) => p.isVerifiedWholesaler).toList();
    }

    // Filtrer par type de produit
    if (filters.isSecondHandOnly) {
      filtered = filtered.where((p) => p.isSecondHand).toList();
    }

    if (filters.isTradableOnly) {
      filtered = filtered.where((p) => p.isTradable).toList();
    }

    // Trier
    switch (filters.sortBy) {
      case SortBy.priceLowToHigh:
        filtered.sort((a, b) => a.priceInFcfa.compareTo(b.priceInFcfa));
        break;
      case SortBy.priceHighToLow:
        filtered.sort((a, b) => b.priceInFcfa.compareTo(a.priceInFcfa));
        break;
      case SortBy.newest:
        // Pour l'instant, on garde l'ordre (à améliorer avec une date de création)
        break;
      case SortBy.mostSold:
        // Pour l'instant, on garde l'ordre (à améliorer avec un compteur de ventes)
        break;
      case SortBy.relevance:
      default:
        // Garder l'ordre original
        break;
    }

    return filtered;
  },
);

