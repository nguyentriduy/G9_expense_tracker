import 'package:flutter/foundation.dart';

import '../models/transaction_model.dart';
import '../services/transaction_local_service.dart';

/// Kiểu filter theo loại giao dịch.
enum TransactionKindFilter { all, income, expense }

/// Provider quản lý danh sách giao dịch, filter ngày, tìm kiếm, loại (Thu/Chi)
/// và tương tác CRUD cơ bản.
class TransactionProvider extends ChangeNotifier {
  TransactionProvider({TransactionLocalService? localService})
      : _localService = localService ?? TransactionLocalService();

  final TransactionLocalService _localService;
  final List<TransactionModel> _items = [];

  DateTime? _fromDate;
  DateTime? _toDate;
  TransactionKindFilter _kindFilter = TransactionKindFilter.all;
  String _searchKeyword = '';

  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get allTransactions => List.unmodifiable(_items);

  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  TransactionKindFilter get kindFilter => _kindFilter;
  String get searchKeyword => _searchKeyword;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load dữ liệu từ local khi khởi tạo app.
  Future<void> loadFromLocal() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loaded = await _localService.loadTransactions();
      _items
        ..clear()
        ..addAll(loaded);
    } catch (e) {
      _errorMessage = 'Có lỗi khi tải dữ liệu. Vui lòng thử lại.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Chỉ filter theo khoảng ngày.
  List<TransactionModel> get _filteredByDate {
    return _items.where((tx) {
      final date = tx.date;
      if (_fromDate != null && date.isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null && date.isAfter(_toDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Danh sách sau khi áp dụng filter ngày, loại (Thu/Chi) và keyword tìm kiếm.
  List<TransactionModel> get visibleTransactions {
    var list = _filteredByDate;

    // Filter theo loại giao dịch.
    if (_kindFilter == TransactionKindFilter.income) {
      list = list.where((tx) => tx.isIncome).toList();
    } else if (_kindFilter == TransactionKindFilter.expense) {
      list = list.where((tx) => !tx.isIncome).toList();
    }

    // Tìm kiếm theo keyword trong categoryName hoặc note.
    if (_searchKeyword.isNotEmpty) {
      final keyword = _searchKeyword.toLowerCase();
      list = list.where((tx) {
        final category = tx.categoryName.toLowerCase();
        final note = (tx.note ?? '').toLowerCase();
        return category.contains(keyword) || note.contains(keyword);
      }).toList();
    }

    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Kết quả đã group theo ngày, dùng cho UI.
  List<TransactionGroupByDate> get groupedByDate =>
      groupTransactionsByDate(visibleTransactions);

  /// API cũ nếu cần: chỉ trả về list sau khi filter theo ngày.
  List<TransactionModel> get filteredTransactions => _filteredByDate
    ..sort((a, b) => b.date.compareTo(a.date));

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

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  void setKindFilter(TransactionKindFilter filter) {
    _kindFilter = filter;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    _items.add(tx);
    notifyListeners();
    await _localService.saveTransactions(_items);
  }

  Future<void> updateTransaction(TransactionModel updated) async {
    final index = _items.indexWhere((tx) => tx.id == updated.id);
    if (index == -1) return;
    _items[index] = updated;
    notifyListeners();
    await _localService.saveTransactions(_items);
  }

  Future<void> deleteTransaction(String id) async {
    _items.removeWhere((tx) => tx.id == id);
    notifyListeners();
    await _localService.saveTransactions(_items);
  }
}
