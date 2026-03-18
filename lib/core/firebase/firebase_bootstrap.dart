import 'package:firebase_core/firebase_core.dart';
import 'package:expense_tracker_app/firebase_options.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
