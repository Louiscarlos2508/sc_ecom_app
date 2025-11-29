import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/price_formatter.dart';
import '../providers/filter_provider.dart';

/// Écran de filtres pour la recherche
class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(productFiltersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: const Text('Filtres'),
        actions: [
          if (filters.hasActiveFilters)
            TextButton(
              onPressed: () {
                ref.read(productFiltersProvider.notifier).clearFilters();
              },
              child: const Text(
                'Réinitialiser',
                style: TextStyle(color: AppColors.onPrimary),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tri
            _FilterSection(
              title: 'Trier par',
              child: Column(
                children: SortBy.values.map((sortBy) {
                  return RadioListTile<SortBy>(
                    title: Text(_getSortByLabel(sortBy)),
                    value: sortBy,
                    groupValue: filters.sortBy,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(productFiltersProvider.notifier).setSortBy(value);
                      }
                    },
                    activeColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Prix
            _FilterSection(
              title: 'Prix (FCFA)',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Prix minimum',
                            hintText: '0',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixText: '  ',
                            suffixText: ' FCFA',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final price = int.tryParse(value);
                            ref.read(productFiltersProvider.notifier).setMinPrice(price);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Prix maximum',
                            hintText: '100000',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixText: '  ',
                            suffixText: ' FCFA',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final price = int.tryParse(value);
                            ref.read(productFiltersProvider.notifier).setMaxPrice(price);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Ville
            _FilterSection(
              title: 'Ville',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Ouagadougou', 'Bobo-Dioulasso', 'Koudougou', 'Ouahigouya', 'Banfora']
                    .map((city) {
                  final isSelected = filters.cities.contains(city);
                  return FilterChip(
                    label: Text(city),
                    selected: isSelected,
                    onSelected: (selected) {
                      ref.read(productFiltersProvider.notifier).toggleCity(city);
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Type de vendeur
            _FilterSection(
              title: 'Type de vendeur',
              child: SwitchListTile(
                title: const Text('Grossiste uniquement'),
                subtitle: const Text('Afficher seulement les produits des grossistes vérifiés'),
                value: filters.isWholesalerOnly,
                onChanged: (value) {
                  ref.read(productFiltersProvider.notifier).setWholesalerOnly(value);
                },
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            // Type de produit
            _FilterSection(
              title: 'Type de produit',
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('D\'occasion uniquement'),
                    subtitle: const Text('Afficher seulement les produits d\'occasion'),
                    value: filters.isSecondHandOnly,
                    onChanged: (value) {
                      ref.read(productFiltersProvider.notifier).setSecondHandOnly(value);
                    },
                    activeColor: AppColors.primary,
                  ),
                  SwitchListTile(
                    title: const Text('Troc disponible'),
                    subtitle: const Text('Afficher seulement les produits échangeables'),
                    value: filters.isTradableOnly,
                    onChanged: (value) {
                      ref.read(productFiltersProvider.notifier).setTradableOnly(value);
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(productFiltersProvider.notifier).clearFilters();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Réinitialiser'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Appliquer (${filters.hasActiveFilters ? 'Filtres actifs' : 'Aucun filtre'})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSortByLabel(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.relevance:
        return 'Pertinence';
      case SortBy.priceLowToHigh:
        return 'Prix croissant';
      case SortBy.priceHighToLow:
        return 'Prix décroissant';
      case SortBy.newest:
        return 'Plus récent';
      case SortBy.mostSold:
        return 'Plus vendu';
    }
  }
}

/// Section de filtre
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

