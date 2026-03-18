import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_app/shared/models/category_item.dart';
import 'package:expense_tracker_app/shared/models/transaction_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
  });

  final double totalIncome;
  final double totalExpense;

  double get balance => totalIncome - totalExpense;
}

class CategoryTransactionStats {
  const CategoryTransactionStats({
    required this.count,
    required this.totalAmount,
    this.lastTransactionDate,
  });

  final int count;
  final double totalAmount;
  final DateTime? lastTransactionDate;
}

class FirestoreDataService {
  FirestoreDataService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _categoriesRef {
    final uid = _uid;
    if (uid == null) {
      return null;
    }
    return _firestore.collection('users').doc(uid).collection('categories');
  }

  CollectionReference<Map<String, dynamic>>? get _transactionsRef {
    final uid = _uid;
    if (uid == null) {
      return null;
    }
    return _firestore.collection('users').doc(uid).collection('transactions');
  }

  Stream<List<CategoryItem>> watchCategories() {
    final ref = _categoriesRef;
    if (ref == null) {
      return Stream.value(const []);
    }

    return ref
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(CategoryItem.fromDoc).toList());
  }

  Stream<List<TransactionItem>> watchTransactions() {
    final ref = _transactionsRef;
    if (ref == null) {
      return Stream.value(const []);
    }

    return ref
        .orderBy('transactionDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(TransactionItem.fromDoc).toList());
  }

  Stream<List<TransactionItem>> watchTransactionsByCategory(String categoryId) {
    final ref = _transactionsRef;
    if (ref == null) {
      return Stream.value(const []);
    }

    return ref.where('categoryId', isEqualTo: categoryId).snapshots().map((
      snapshot,
    ) {
      final items = snapshot.docs.map(TransactionItem.fromDoc).toList();
      items.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
      return items;
    });
  }

  Stream<DashboardSummary> watchDashboardSummary() {
    return watchTransactions().map((items) {
      var income = 0.0;
      var expense = 0.0;

      for (final item in items) {
        if (item.type == 'income') {
          income += item.amount;
        } else {
          expense += item.amount;
        }
      }

      return DashboardSummary(totalIncome: income, totalExpense: expense);
    });
  }

  Stream<Map<String, CategoryTransactionStats>>
  watchCategoryTransactionStats() {
    return watchTransactions().map((items) {
      final result = <String, CategoryTransactionStats>{};

      for (final item in items) {
        final previous = result[item.categoryId];
        if (previous == null) {
          result[item.categoryId] = CategoryTransactionStats(
            count: 1,
            totalAmount: item.amount,
            lastTransactionDate: item.transactionDate,
          );
          continue;
        }

        final previousDate = previous.lastTransactionDate;
        final latestDate =
            previousDate == null || item.transactionDate.isAfter(previousDate)
            ? item.transactionDate
            : previousDate;

        result[item.categoryId] = CategoryTransactionStats(
          count: previous.count + 1,
          totalAmount: previous.totalAmount + item.amount,
          lastTransactionDate: latestDate,
        );
      }

      return result;
    });
  }

  Future<void> createTransaction({
    required String type,
    required CategoryItem category,
    required double amount,
    required String note,
    DateTime? transactionDate,
  }) async {
    final ref = _transactionsRef;
    if (ref == null) {
      throw StateError('Chưa đăng nhập');
    }

    final date = transactionDate ?? DateTime.now();

    await ref.add({
      'type': type,
      'categoryId': category.id,
      'categoryName': category.name,
      'amount': amount,
      'note': note,
      'transactionDate': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTransaction(String transactionId) async {
    final ref = _transactionsRef;
    if (ref == null) {
      throw StateError('Chưa đăng nhập');
    }

    await ref.doc(transactionId).delete();
  }
}
