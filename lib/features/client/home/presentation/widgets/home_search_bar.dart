import 'package:flutter/material.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/features/client/search/presentation/screens/search_screen.dart';

/// Barre de recherche pour l'AppBar du HomeScreen
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Rechercher un produit...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  // TODO: Recherche par image
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
      ),
    );
  }
}

