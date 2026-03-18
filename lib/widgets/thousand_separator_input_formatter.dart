import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// TextInputFormatter dùng để format số tiền với dấu phân cách hàng nghìn
/// trong khi người dùng nhập liệu.
class ThousandSeparatorInputFormatter extends TextInputFormatter {
  ThousandSeparatorInputFormatter({
    this.locale = 'vi_VN',
  });

  final String locale;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Nếu xóa hết thì trả về rỗng
    if (newValue.text.trim().isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Loại bỏ mọi ký tự không phải số
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse sang int
    final number = int.tryParse(digitsOnly);
    if (number == null) {
      return oldValue;
    }

    // Format lại với dấu phẩy
    final formatter = NumberFormat.decimalPattern(locale);
    final newText = formatter.format(number);

    // Đặt con trỏ ở cuối chuỗi
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
