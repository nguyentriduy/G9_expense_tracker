import 'package:flutter/foundation.dart';

import '../models/transaction_model.dart';

/// Provider quản lý danh sách giao dịch và filter theo khoảng thời gian.
class TransactionProvider extends ChangeNotifier {
  final List<TransactionModel> _items = [];

  DateTime? _fromDate;
  DateTime? _toDate;

  List<TransactionModel> get allTransactions => List.unmodifiable(_items);

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  /// Các giao dịch sau khi áp dụng filter ngày.
  List<TransactionModel> get filteredTransactions {
    return _items.where((tx) {
      final date = tx.date;
      if (_fromDate != null && date.isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null && date.isAfter(_toDate!)) {
        return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Kết quả đã group theo ngày, dùng cho UI.
  List<TransactionGroupByDate> get groupedByDate =>
      groupTransactionsByDate(filteredTransactions);

  void setFilter({DateTime? from, DateTime? to}) {
    _fromDate = from;
    _toDate = to;
    notifyListeners();
  }

  void clearFilter() {
    _fromDate = null;
    _toDate = null;
    notifyListeners();
  }

  void addTransaction(TransactionModel tx) {
    _items.add(tx);
    notifyListeners();
  }
}
