import 'package:flutter/foundation.dart';

import '../shared/models/transaction_model.dart';
import '../services/transaction_local_service.dart';
import '../core/firebase/transaction_firebase_service.dart';

enum TransactionKindFilter { all, income, expense }

class TransactionProvider extends ChangeNotifier {
  TransactionProvider({
    TransactionLocalService? localService,
    TransactionFirebaseService? remoteService,
  })  : _localService = localService ?? TransactionLocalService(),
        _remoteService = !kIsWeb
            ? (remoteService ?? TransactionFirebaseService())
            : null;

  final TransactionLocalService _localService;
  final TransactionFirebaseService? _remoteService;
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

  int get totalIncome {
    var sum = 0;
    for (final tx in _items) {
      if (tx.isIncome) {
        sum += tx.amount;
      }
    }
    return sum;
  }

  int get totalExpense {
    var sum = 0;
    for (final tx in _items) {
      if (!tx.isIncome) {
        sum += tx.amount;
      }
    }
    return sum;
  }

  int get balance => totalIncome - totalExpense;

  Future<void> loadFromLocal() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!kIsWeb && _remoteService != null) {
        final loadedRemote = await _remoteService!.loadTransactions();
        _items
          ..clear()
          ..addAll(loadedRemote);
        await _localService.saveTransactions(_items);
      } else {
        final loadedLocal = await _localService.loadTransactions();
        _items
          ..clear()
          ..addAll(loadedLocal);
      }
    } catch (e) {
      try {
        final loadedLocal = await _localService.loadTransactions();
        _items
          ..clear()
          ..addAll(loadedLocal);
      } catch (_) {}
      _errorMessage = 'Có lỗi khi tải dữ liệu. Vui lòng thử lại.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<TransactionModel> get _filteredByDate {
    return _items.where((tx) {
      final date = tx.dateOnly;
      if (_fromDate != null && date.isBefore(_fromDate!)) {
        return false;
      }
      if (_toDate != null && date.isAfter(_toDate!)) {
        return false;
      }
      return true;
    }).toList();
  }

  List<TransactionModel> get visibleTransactions {
    var list = _filteredByDate;

    if (_kindFilter == TransactionKindFilter.income) {
      list = list.where((tx) => tx.isIncome).toList();
    } else if (_kindFilter == TransactionKindFilter.expense) {
      list = list.where((tx) => !tx.isIncome).toList();
    }

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

  List<TransactionGroupByDate> get groupedByDate =>
      groupTransactionsByDate(visibleTransactions);

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
    if (!kIsWeb && _remoteService != null) {
      await _remoteService!.addOrUpdateTransaction(tx);
    }
  }

  Future<void> updateTransaction(TransactionModel updated) async {
    final index = _items.indexWhere((tx) => tx.id == updated.id);
    if (index == -1) return;
    _items[index] = updated;
    notifyListeners();
    await _localService.saveTransactions(_items);
    if (!kIsWeb && _remoteService != null) {
      await _remoteService!.addOrUpdateTransaction(updated);
    }
  }

  Future<void> deleteTransaction(String id) async {
    _items.removeWhere((tx) => tx.id == id);
    notifyListeners();
    await _localService.saveTransactions(_items);
    if (!kIsWeb && _remoteService != null) {
      await _remoteService!.deleteTransaction(id);
    }
  }
}
