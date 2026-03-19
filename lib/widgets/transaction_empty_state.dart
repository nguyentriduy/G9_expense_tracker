import 'package:flutter/material.dart';

class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bạn chưa có giao dịch nào...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
