import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionItem {
  const TransactionItem({
    required this.id,
    required this.type,
    required this.categoryId,
    required this.category,
    required this.amount,
    required this.note,
    required this.transactionDate,
  });

  final String id;
  final String type;
  final String categoryId;
  final String category;
  final double amount;
  final String note;
  final DateTime transactionDate;

  factory TransactionItem.fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final timestamp = data['transactionDate'] as Timestamp?;

    return TransactionItem(
      id: doc.id,
      type: data['type'] as String? ?? 'expense',
      categoryId: data['categoryId'] as String? ?? '',
      category: data['categoryName'] as String? ?? 'Khác',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      note: data['note'] as String? ?? '',
      transactionDate: timestamp?.toDate() ?? DateTime.now(),
    );
  }
}
