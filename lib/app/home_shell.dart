import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_theme_controller.dart';
import 'package:expense_tracker_app/features/categories/presentation/categories_page.dart';
import 'package:expense_tracker_app/features/dashboard/presentation/dashboard_page.dart';
import 'package:expense_tracker_app/features/reports/presentation/reports_page.dart';
import 'package:expense_tracker_app/features/settings/presentation/settings_page.dart';
import 'package:expense_tracker_app/features/transactions/presentation/transaction_list_screen.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
				const DashboardPage(),
				const _TransactionsTab(),
				const CategoriesPage(),
				const ReportsPage(),
				SettingsPage(
					themeController: widget.themeController,
					onSignedOut: (context) async {
						Navigator.pushNamedAndRemoveUntil(
							context,
							AppRoutes.login,
							(route) => false,
						);
					},
				),
			];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: _selectedIndex == 1
					? null
					: AppBar(
							title: Text(_titles[_selectedIndex]),
						),
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

class _TransactionsTab extends StatelessWidget {
	const _TransactionsTab();

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (_) => TransactionProvider()..loadFromLocal(),
			child: const TransactionListScreen(),
		);
	}
}

