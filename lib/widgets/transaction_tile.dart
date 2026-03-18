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

  String get _typeLabel => transaction.isIncome ? 'TIỀN VÀO' : 'TIỀN RA';

  Color get _amountColor => transaction.isIncome ? Colors.greenAccent : Colors.redAccent;

  String get _sign => transaction.isIncome ? '+' : '-';

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
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
                  _typeLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.note?.isNotEmpty == true
                      ? transaction.note!
                      : _formatTime(transaction.date),
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
