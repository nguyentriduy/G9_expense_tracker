import 'package:flutter/foundation.dart';

/// Domain model đại diện cho một giao dịch tài chính.
class TransactionModel {
  final String id;
  final int amount; // Đơn vị: VNĐ, lưu dạng số nguyên để tránh lỗi float
  final bool isIncome; // true = Thu (TIỀN VÀO), false = Chi (TIỀN RA)
  final String categoryName;
  final String? note;
  final DateTime date; // Bao gồm cả ngày + giờ

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.isIncome,
    required this.categoryName,
    this.note,
    required this.date,
  });

  /// Trả về ngày (không có giờ) để phục vụ group theo ngày.
  DateTime get dateOnly => DateTime(date.year, date.month, date.day);
}

/// Cấu trúc dữ liệu sau khi đã group theo ngày để render UI.
class TransactionGroupByDate {
  final DateTime date;
  final List<TransactionModel> transactions;

  const TransactionGroupByDate({
    required this.date,
    required this.transactions,
  });
}

/// Hàm tiện ích: nhận danh sách phẳng và group theo ngày.
List<TransactionGroupByDate> groupTransactionsByDate(
  List<TransactionModel> items,
) {
  // Map tạm: key là ngày, value là list giao dịch trong ngày đó
  final Map<DateTime, List<TransactionModel>> grouped = {};

  for (final tx in items) {
    final key = tx.dateOnly;
    grouped.putIfAbsent(key, () => <TransactionModel>[]).add(tx);
  }

  // Chuyển map thành list và sort theo ngày mới nhất -> cũ nhất
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
