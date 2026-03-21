import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreBootstrapService {
  FirestoreBootstrapService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const bool _seedSampleTransactions = false;

  final FirebaseFirestore _firestore;

  Future<void> ensureUserStructure(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    final now = DateTime.now();

    await userRef.set({
      'displayName': user.displayName ?? 'User',
      'email': user.email ?? '',
      'currency': 'VND',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final categoriesRef = userRef.collection('categories');
    final monthlySummaryRef = userRef.collection('monthly_summary');

    final defaultCategories = <Map<String, dynamic>>[
      {
        'id': 'expense_food',
        'name': 'Ăn uống',
        'type': 'expense',
        'icon': 'restaurant',
        'color': 0xFFEF5350,
        'isDefault': true,
      },
      {
        'id': 'expense_transport',
        'name': 'Đi lại',
        'type': 'expense',
        'icon': 'directions_car',
        'color': 0xFF42A5F5,
        'isDefault': true,
      },
      {
        'id': 'expense_shopping',
        'name': 'Mua sắm',
        'type': 'expense',
        'icon': 'shopping_bag',
        'color': 0xFFAB47BC,
        'isDefault': true,
      },
      {
        'id': 'expense_entertainment',
        'name': 'Giải trí',
        'type': 'expense',
        'icon': 'local_activity',
        'color': 0xFF7E57C2,
        'isDefault': true,
      },
      {
        'id': 'expense_other',
        'name': 'Khác',
        'type': 'expense',
        'icon': 'category',
        'color': 0xFF607D8B,
        'isDefault': true,
      },
      {
        'id': 'income_salary',
        'name': 'Lương',
        'type': 'income',
        'icon': 'payments',
        'color': 0xFF66BB6A,
        'isDefault': true,
      },
      {
        'id': 'income_bonus',
        'name': 'Thưởng',
        'type': 'income',
        'icon': 'workspace_premium',
        'color': 0xFFFFA726,
        'isDefault': true,
      },
    ];

    final batch = _firestore.batch();

    for (final category in defaultCategories) {
      final categoryId = category['id'] as String;
      batch.set(categoriesRef.doc(categoryId), {
        ...category,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    final monthKey = _monthKey(now);
    batch.set(monthlySummaryRef.doc(monthKey), {
      'month': monthKey,
      'totalIncome': 0,
      'totalExpense': 0,
      'balanceChange': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final transactionsRef = userRef.collection('transactions');
    final hasTransaction = await transactionsRef.limit(1).get();
    if (_seedSampleTransactions && hasTransaction.docs.isEmpty) {
      final sampleTransactions = [
        {
          'type': 'income',
          'categoryId': 'income_salary',
          'categoryName': 'Lương',
          'amount': 18000000,
          'note': 'Lương tháng này',
          'transactionDate': Timestamp.fromDate(
            DateTime(now.year, now.month, 1),
          ),
        },
        {
          'type': 'expense',
          'categoryId': 'expense_food',
          'categoryName': 'Ăn uống',
          'amount': 350000,
          'note': 'Chi tiêu ăn uống tuần 1',
          'transactionDate': Timestamp.fromDate(
            DateTime(now.year, now.month, 3),
          ),
        },
        {
          'type': 'expense',
          'categoryId': 'expense_transport',
          'categoryName': 'Đi lại',
          'amount': 200000,
          'note': 'Xăng xe',
          'transactionDate': Timestamp.fromDate(
            DateTime(now.year, now.month, 5),
          ),
        },
      ];

      for (final item in sampleTransactions) {
        batch.set(transactionsRef.doc(), {
          ...item,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    await batch.commit();
  }

  String _monthKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return '${date.year}$month';
  }
}
