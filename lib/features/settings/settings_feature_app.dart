import 'package:expense_tracker_app/core/theme/app_theme.dart';
import 'package:expense_tracker_app/core/theme/app_theme_controller.dart';
import 'package:expense_tracker_app/features/settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';

class SettingsFeatureApp extends StatefulWidget {
  const SettingsFeatureApp({super.key});

  @override
  State<SettingsFeatureApp> createState() => _SettingsFeatureAppState();
}

class _SettingsFeatureAppState extends State<SettingsFeatureApp> {
  final _themeController = AppThemeController();

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
          title: 'Expense Tracker - Settings',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeController.themeMode,
          home: Scaffold(
            appBar: AppBar(title: const Text('Tài khoản cá nhân')),
            body: SettingsPage(themeController: _themeController),
          ),
        );
      },
    );
  }
}
