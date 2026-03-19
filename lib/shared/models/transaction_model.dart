import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TransactionModel {
  final String id;
  final int amount;
  final bool isIncome;
  final String categoryName;
  final String? note;
  final DateTime date;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.isIncome,
    required this.categoryName,
    this.note,
    required this.date,
  });

  DateTime get dateOnly => DateTime(date.year, date.month, date.day);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'isIncome': isIncome,
      'categoryName': categoryName,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: json['amount'] as int,
      isIncome: json['isIncome'] as bool,
      categoryName: json['categoryName'] as String,
      note: json['note'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }

  factory TransactionModel.fromFirestore(
    Map<String, dynamic> data, {
    required String id,
  }) {
    final amountRaw = data['amount'];
    final amount = amountRaw is int
        ? amountRaw
        : (amountRaw is num ? amountRaw.round() : 0);

    bool isIncome;
    final isIncomeRaw = data['isIncome'];
    if (isIncomeRaw is bool) {
      isIncome = isIncomeRaw;
    } else {
      final type = (data['type'] as String?) ?? 'expense';
      isIncome = type == 'income';
    }

    final rawCategoryName = (data['categoryName'] as String?) ??
        (data['category'] as String?);
    final categoryName = rawCategoryName == null ||
            rawCategoryName.trim().isEmpty
        ? 'Khác'
        : rawCategoryName.trim();

    final rawNote = data['note'];
    String? note;
    if (rawNote is String && rawNote.trim().isNotEmpty) {
      note = rawNote.trim();
    }

    DateTime date;
    final transactionDate = data['transactionDate'];
    if (transactionDate is Timestamp) {
      date = transactionDate.toDate();
    } else if (data['date'] is String) {
      date = DateTime.tryParse(data['date'] as String) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return TransactionModel(
      id: id,
      amount: amount,
      isIncome: isIncome,
      categoryName: categoryName,
      note: note,
      date: date,
    );
  }
}

class TransactionGroupByDate {
  final DateTime date;
  final List<TransactionModel> transactions;

  const TransactionGroupByDate({
    required this.date,
    required this.transactions,
  });
}

List<TransactionGroupByDate> groupTransactionsByDate(
  List<TransactionModel> items,
) {
  final Map<DateTime, List<TransactionModel>> grouped = {};

  for (final tx in items) {
    final key = tx.dateOnly;
    grouped.putIfAbsent(key, () => <TransactionModel>[]).add(tx);
  }

  final result = grouped.entries
      .map(
        (e) => TransactionGroupByDate(
          date: e.key,
          transactions: List<TransactionModel>.from(e.value)
            ..sort((a, b) => b.date.compareTo(a.date)),
        ),
      )
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));

  return result;
}
