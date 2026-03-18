import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool _firebaseInitialized = false;

bool get isFirebaseInitialized => _firebaseInitialized;

Future<void> initFirebaseIfNeeded() async {
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signInAnonymously();
      _firebaseInitialized = true;
    } catch (e, st) {
      debugPrint('Firebase init/auth failed: $e');
      debugPrint('$st');
      _firebaseInitialized = false;
    }
  }
}
