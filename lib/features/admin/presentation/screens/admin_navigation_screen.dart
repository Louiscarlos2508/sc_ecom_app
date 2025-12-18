import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/core/theme/app_colors.dart';
import '../providers/admin_navigation_provider.dart';
import 'admin_dashboard_screen.dart';
import 'admin_sellers_screen.dart';
import '../../../client/profile/presentation/screens/account_screen.dart';

/// Navigation admin avec bottom bar
class AdminNavigationScreen extends ConsumerWidget {
  const AdminNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminNavigationIndexProvider);

    final List<Widget> screens = [
      const AdminDashboardScreen(),
      const AdminSellersScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(adminNavigationIndexProvider.notifier).setIndex(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.error,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Vendeurs',
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

