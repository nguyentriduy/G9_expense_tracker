import 'package:flutter/material.dart';

/// Widget hiển thị khi chưa có giao dịch nào.
class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.white24,
          ),
          SizedBox(height: 12),
          Text(
            'Bạn chưa có giao dịch nào...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
