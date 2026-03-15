import 'package:flutter/material.dart';
import 'package:expense_tracker_app/app/expense_tracker_app.dart';
import 'package:expense_tracker_app/core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const ExpenseTrackerApp());
}
