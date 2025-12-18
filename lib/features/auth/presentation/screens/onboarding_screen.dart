import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/core/theme/app_colors.dart';
import 'login_screen.dart';
import '../providers/onboarding_provider.dart';

/// Modèle pour une page d'onboarding
class OnboardingPage {
  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

/// Liste des pages d'onboarding (4 slides)
List<OnboardingPage> _getOnboardingPages() {
  return [
    const OnboardingPage(
      icon: Icons.shopping_cart,
      title: 'Achetez en ligne',
      description:
          'Découvrez des milliers de produits locaux à des prix imbattables en FCFA',
      color: AppColors.primary,
    ),
    const OnboardingPage(
      icon: Icons.store,
      title: 'Vendez facilement',
      description:
          'Devenez vendeur et vendez vos produits à travers tout le Burkina Faso',
      color: AppColors.success,
    ),
    const OnboardingPage(
      icon: Icons.local_shipping,
      title: 'Livraison rapide',
      description:
          'Livraison rapide et sécurisée à Ouagadougou, Bobo, Koudougou et partout',
      color: AppColors.warning,
    ),
    const OnboardingPage(
      icon: Icons.card_giftcard,
      title: 'Code parrainage',
      description:
          'Parrainez vos amis et gagnez des avantages. Le bouche-à-oreille, c\'est notre force !',
      color: AppColors.primary,
    ),
  ];
}

/// Écran d'onboarding ECONOMAX
/// Présente les fonctionnalités principales de l'app (4 slides)
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _nextPage(
    BuildContext context,
    WidgetRef ref,
    PageController controller,
    int currentPage,
    List<OnboardingPage> pages,
  ) {
    if (currentPage < pages.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(onboardingCurrentPageProvider);
    final pageController = ref.watch(onboardingPageControllerProvider);
    final pages = _getOnboardingPages();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _goToLogin(context),
                child: Text(
                  'Passer',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
            // PageView avec 4 slides
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  ref.read(onboardingCurrentPageProvider.notifier).setPage(index);
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPageWidget(page: pages[index]);
                },
              ),
            ),
            // Indicateurs de page (4 indicateurs)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => _PageIndicator(
                  isActive: index == currentPage,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Bouton suivant/commencer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _nextPage(
                    context,
                    ref,
                    pageController,
                    currentPage,
                    pages,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    currentPage == pages.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Widget pour une page d'onboarding
class _OnboardingPageWidget extends StatelessWidget {
  const _OnboardingPageWidget({required this.page});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône animée
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: page.color,
            ),
          ),
          const SizedBox(height: 48),
          // Titre
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Indicateur de page
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
