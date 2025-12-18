import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/core/theme/app_colors.dart';
import '../providers/seller_navigation_provider.dart';
import 'package:economax/features/seller/dashboard/presentation/screens/seller_dashboard_screen.dart';
import 'package:economax/features/seller/products/presentation/screens/seller_products_screen.dart';
import 'package:economax/features/seller/orders/presentation/screens/seller_orders_screen.dart';
import 'package:economax/features/client/profile/presentation/screens/account_screen.dart';

/// Navigation vendeur avec bottom bar
class SellerNavigationScreen extends ConsumerWidget {
  const SellerNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(sellerNavigationIndexProvider);

    final List<Widget> screens = [
      const SellerDashboardScreen(),
      const SellerProductsScreen(),
      const SellerOrdersScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(sellerNavigationIndexProvider.notifier).setIndex(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Mes produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Ventes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Moi',
          ),
        ],
      ),
    );
  }
}

