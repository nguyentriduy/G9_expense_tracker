import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../features/transactions/presentation/add_transaction_screen.dart';
import 'home_shell.dart';

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1ABC9C),
      brightness: Brightness.dark,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..loadFromLocal(),
        ),
      ],
      child: MaterialApp(
        title: 'G9 Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
          scaffoldBackgroundColor: const Color(0xFF020B12),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF1ABC9C),
          ),
        ),
        home: const HomeShell(),
        routes: {
          AddTransactionScreen.routeName: (_) => const AddTransactionScreen(),
        },
      ),
    );
  }
}
