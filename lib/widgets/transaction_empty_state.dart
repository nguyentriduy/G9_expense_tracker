import 'package:flutter/material.dart';

/// Widget hiển thị khi chưa có giao dịch nào.
class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Chưa có giao dịch nào',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
