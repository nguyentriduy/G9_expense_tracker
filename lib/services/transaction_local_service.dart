import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_model.dart';

/// Service lưu trữ giao dịch trên local bằng SharedPreferences.
///
/// Dùng cho bài toán demo: dữ liệu vẫn còn sau khi tắt app / hot restart,
/// nhưng không cần cài đặt DB phức tạp.
class TransactionLocalService {
  static const _storageKey = 'transactions_v1';

  Future<List<TransactionModel>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Nếu dữ liệu lỗi format thì trả về rỗng để tránh crash.
      return [];
    }
  }

  Future<void> saveTransactions(List<TransactionModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((e) => e.toJson()).toList();
    final raw = jsonEncode(jsonList);
    await prefs.setString(_storageKey, raw);
  }
}
