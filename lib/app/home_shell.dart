import 'package:expense_tracker_app/core/theme/app_theme_controller.dart';
import 'package:expense_tracker_app/features/settings/presentation/settings_page.dart';
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
    const _MinimalTabPage(),
    const _MinimalTabPage(),
    const _MinimalTabPage(),
    const _MinimalTabPage(),
    SettingsPage(themeController: widget.themeController),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
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

class _MinimalTabPage extends StatelessWidget {
  const _MinimalTabPage();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
