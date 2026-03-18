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
