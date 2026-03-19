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
    final snapshot =
        await _collection.orderBy('transactionDate', descending: true).get();
    return snapshot.docs
        .map(
          (doc) => TransactionModel.fromFirestore(
            doc.data(),
            id: doc.id,
          ),
        )
        .toList();
  }

  Future<void> addOrUpdateTransaction(TransactionModel tx) async {
    await _collection.doc(tx.id).set({
      'type': tx.isIncome ? 'income' : 'expense',
      'categoryId': '',
      'categoryName': tx.categoryName,
      'amount': tx.amount.toDouble(),
      'note': tx.note ?? '',
      'transactionDate': Timestamp.fromDate(tx.date),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteTransaction(String id) async {
    await _collection.doc(id).delete();
  }
}
