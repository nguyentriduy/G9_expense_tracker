import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/app/expense_tracker_app.dart';
import 'package:expense_tracker_app/core/firebase/firebase_bootstrap.dart';
import 'package:expense_tracker_app/shared/providers/transaction_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(
    // Đăng ký Provider tại đây để toàn bộ App có thể dùng dữ liệu
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const ExpenseTrackerApp(),
    ),
  );
}


