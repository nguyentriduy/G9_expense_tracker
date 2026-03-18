import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

/// Một dòng giao dịch giống sao kê ngân hàng.
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  Color get _amountColor => transaction.isIncome ? Colors.greenAccent : Colors.redAccent;

  String get _sign => transaction.isIncome ? '+' : '-';

  String _formatDateTime(DateTime date) {
    // Định dạng dd/MM/yyyy HH:mm theo yêu cầu.
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String _formatAmount(int amount) {
    final formatter = NumberFormat.decimalPattern('vi_VN');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1ABC9C).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: const Color(0xFF1ABC9C),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  // Ví dụ: "TIỀN VÀO • 18/03/2026 14:06"
                  '${transaction.isIncome ? 'TIỀN VÀO' : 'TIỀN RA'} • ${_formatDateTime(transaction.date)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$_sign${_formatAmount(transaction.amount)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _amountColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
