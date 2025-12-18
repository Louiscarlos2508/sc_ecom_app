import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:economax/shared/core/theme/app_colors.dart';
import 'package:economax/features/client/home/presentation/screens/home_screen.dart';
import 'package:economax/features/client/cart/presentation/screens/cart_screen.dart';
import 'package:economax/features/client/orders/presentation/screens/order_list_screen.dart';
import 'package:economax/features/client/profile/presentation/screens/account_screen.dart';
import 'package:economax/features/client/home/presentation/providers/navigation_provider.dart';

/// Navigation principale avec bottom bar
class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final List<Widget> screens = [
      HomeScreen(),
      const CartScreen(),
      const OrderListScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
          onTap: (index) {
            ref.read(navigationIndexProvider.notifier).setIndex(index);
          },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mon compte',
          ),
        ],
      ),
    );
  }
}

