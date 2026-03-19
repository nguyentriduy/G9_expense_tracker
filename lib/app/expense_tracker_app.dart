import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/app/home_shell.dart';
import 'package:expense_tracker_app/core/theme/app_theme.dart';
import 'package:expense_tracker_app/core/theme/app_theme_controller.dart';
import 'package:expense_tracker_app/features/auth/presentation/forgot_password_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/login_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/register_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/splash_page.dart';
import 'package:expense_tracker_app/features/categories/presentation/category_detail_page.dart';
import 'package:expense_tracker_app/features/transactions/presentation/transaction_detail_page.dart';
import 'package:expense_tracker_app/features/transactions/presentation/transaction_filter_page.dart';
import 'package:expense_tracker_app/features/transactions/presentation/transaction_form_page.dart';
import 'package:flutter/material.dart';

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  final AppThemeController _themeController = AppThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.load();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Expense Tracker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeController.themeMode,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.splash:
                return MaterialPageRoute<void>(
                  builder: (_) => const SplashPage(),
                  settings: settings,
                );
              case AppRoutes.login:
                return MaterialPageRoute<void>(
                  builder: (_) => const LoginPage(),
                  settings: settings,
                );
              case AppRoutes.register:
                return MaterialPageRoute<void>(
                  builder: (_) => const RegisterPage(),
                  settings: settings,
                );
              case AppRoutes.forgotPassword:
                return MaterialPageRoute<void>(
                  builder: (_) => const ForgotPasswordPage(),
                  settings: settings,
                );
              case AppRoutes.home:
                return MaterialPageRoute<void>(
                  builder: (_) => HomeShell(themeController: _themeController),
                  settings: settings,
                );
              case AppRoutes.transactionForm:
                return MaterialPageRoute<void>(
                  builder: (_) => const TransactionFormPage(),
                  settings: settings,
                );
              case AppRoutes.transactionDetail:
                return MaterialPageRoute<void>(
                  builder: (_) => const TransactionDetailPage(),
                  settings: settings,
                );
              case AppRoutes.transactionFilter:
                return MaterialPageRoute<void>(
                  builder: (_) => const TransactionFilterPage(),
                  settings: settings,
                );
              case AppRoutes.categoryDetail:
                return MaterialPageRoute<void>(
                  builder: (_) => const CategoryDetailPage(),
                  settings: settings,
                );
            }

            return null;
          },
        );
      },
    );
  }
}
