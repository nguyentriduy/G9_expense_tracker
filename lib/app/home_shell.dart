<<<<<<< HEAD
import 'package:expense_tracker_app/core/theme/app_theme_controller.dart';
import 'package:expense_tracker_app/features/settings/presentation/settings_page.dart';
=======
import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_theme_controller.dart';
import 'package:expense_tracker_app/features/categories/presentation/categories_page.dart';
import 'package:expense_tracker_app/features/dashboard/presentation/dashboard_page.dart';
import 'package:expense_tracker_app/features/reports/presentation/reports_page.dart';
import 'package:expense_tracker_app/features/settings/presentation/settings_page.dart';
import 'package:expense_tracker_app/features/transactions/presentation/transactions_page.dart';
>>>>>>> origin/feature/categories
import 'package:flutter/material.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.themeController});

  final AppThemeController themeController;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const _titles = [
    'Tổng quan tài chính',
    'Giao dịch',
    'Danh mục',
    'Thống kê',
    'Tài khoản cá nhân',
  ];

  List<Widget> get _pages => [
<<<<<<< HEAD
    const _MinimalTabPage(),
    const _MinimalTabPage(),
    const _MinimalTabPage(),
    const _MinimalTabPage(),
=======
    const DashboardPage(),
    const TransactionsPage(),
    const CategoriesPage(),
    const ReportsPage(),
>>>>>>> origin/feature/categories
    SettingsPage(themeController: widget.themeController),
  ];

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
=======
    final isTransactionTab = _selectedIndex == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: isTransactionTab
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.transactionFilter);
                  },
                  icon: const Icon(Icons.filter_alt_outlined),
                  tooltip: 'Bộ lọc',
                ),
              ]
            : null,
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: isTransactionTab
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.transactionForm);
              },
              icon: const Icon(Icons.add),
              label: const Text('Thêm giao dịch'),
            )
          : null,
>>>>>>> origin/feature/categories
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Danh mục',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
<<<<<<< HEAD

class _MinimalTabPage extends StatelessWidget {
  const _MinimalTabPage();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
=======
>>>>>>> origin/feature/categories
