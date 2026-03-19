import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker_app/shared/models/transaction_item.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionItem> _transactions = [];

  List<TransactionItem> get transactions => _transactions;

  // --- LOGIC TÍNH TOÁN CHO DASHBOARD ---

  // Tính tổng thu (dựa trên field 'type' trong Model của bạn)
  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, item) => sum + item.amount);

  // Tính tổng chi (dựa trên field 'type' trong Model của bạn)
  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, item) => sum + item.amount);

  // Số dư hiện tại (Tiền tiết kiệm)
  double get totalBalance => totalIncome - totalExpense;

  // --- THAO TÁC DỮ LIỆU ---

  // Cập nhật danh sách từ Firebase hoặc Mock Data
  void setTransactions(List<TransactionItem> items) {
    _transactions = items;
    _sortTransactions();
    saveToLocal(); // Lưu lại vào máy
    notifyListeners(); // Thông báo cho Dashboard cập nhật số liệu
  }

  // Thêm giao dịch mới
  void addTransaction(TransactionItem item) {
    _transactions.add(item);
    _sortTransactions();
    saveToLocal();
    notifyListeners();
  }

  // Xóa giao dịch
  void deleteTransaction(String id) {
    _transactions.removeWhere((item) => item.id == id);
    saveToLocal();
    notifyListeners();
  }

  // Sắp xếp giao dịch mới nhất lên đầu
  void _sortTransactions() {
    _transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
  }

  // --- LƯU TRỮ OFFLINE (Bài test Kill App) ---

  Future<void> saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Vì TransactionItem của bạn chưa có toMap, bạn có thể lưu thủ công 
      // hoặc dùng Firebase làm nguồn chính. Ở đây mình giả định lưu JSON:
      /*
      final data = jsonEncode(_transactions.map((e) => { ... }).toList());
      await prefs.setString('transactions_cache', data);
      */
    } catch (e) {
      debugPrint("Lỗi lưu local: $e");
    }
  }
}