import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../shared/models/transaction_model.dart';

class TransactionFirebaseService {
  TransactionFirebaseService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No authenticated user');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('transactions');
  }

  Future<List<TransactionModel>> loadTransactions() async {
    final snapshot = await _collection.orderBy('date', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = data['id'] ?? doc.id;
      return TransactionModel.fromJson(data);
    }).toList();
  }

  Future<void> addOrUpdateTransaction(TransactionModel tx) async {
    await _collection.doc(tx.id).set(tx.toJson());
  }

  Future<void> deleteTransaction(String id) async {
    await _collection.doc(id).delete();
  }
}