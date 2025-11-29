import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../widgets/search_suggestions.dart';
import '../widgets/search_results.dart';

/// Écran de recherche amélioré (inspiré AliExpress)
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Téléphone',
    'Vêtements',
    'Électronique',
    'Riz',
    'Arachides',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(() {});
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final hasQuery = query.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: AppColors.onPrimary),
          decoration: InputDecoration(
            hintText: 'Rechercher un produit...',
            hintStyle: TextStyle(
              color: AppColors.onPrimary.withOpacity(0.7),
            ),
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasQuery)
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.onPrimary,
                    ),
                    onPressed: _clearSearch,
                  ),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: AppColors.onPrimary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recherche par image bientôt disponible'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: AppColors.onPrimary,
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: hasQuery
          ? SearchResults(query: query)
          : SearchSuggestions(
              recentSearches: _recentSearches,
              onSearchTap: (searchQuery) {
                _searchController.text = searchQuery;
                setState(() {});
              },
            ),
    );
  }
}
