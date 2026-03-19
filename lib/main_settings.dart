import 'package:expense_tracker_app/core/firebase/firebase_bootstrap.dart';
import 'package:expense_tracker_app/features/settings/settings_feature_app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const SettingsFeatureApp());
}
