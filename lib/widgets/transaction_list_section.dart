import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../widgets/transaction_tile.dart';

/// Một card đại diện cho 1 ngày, bên trong là danh sách transaction của ngày đó.
class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    super.key,
    required this.group,
    required this.onTapTransaction,
    required this.onDeleteTransaction,
  });

  final TransactionGroupByDate group;
  final void Function(TransactionModel transaction) onTapTransaction;
  final Future<void> Function(TransactionModel transaction) onDeleteTransaction;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF0F1822),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _formatDate(group.date),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ...group.transactions.map(
              (tx) => Dismissible(
                key: ValueKey(tx.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Xác nhận xóa'),
                      content: const Text('Bạn có chắc chắn muốn xóa?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Xóa'),
                        ),
                      ],
                    ),
                  );
                  return result ?? false;
                },
                onDismissed: (_) => onDeleteTransaction(tx),
                child: InkWell(
                  onTap: () => onTapTransaction(tx),
                  child: TransactionTile(transaction: tx),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
