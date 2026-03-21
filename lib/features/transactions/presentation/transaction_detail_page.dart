import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:expense_tracker_app/shared/models/transaction_item.dart';
import 'package:expense_tracker_app/shared/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final _dataService = FirestoreDataService();
  bool _isDeleting = false;

  Future<void> _deleteTransaction(TransactionItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa giao dịch'),
          content: const Text('Bạn có chắc muốn xóa giao dịch này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await _dataService.deleteTransaction(item.id);
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa giao dịch')));
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa giao dịch thất bại, vui lòng thử lại'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final item = args is TransactionItem ? args : null;
    final model = args is TransactionModel ? args : null;
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );
    final dateText = item != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(item.transactionDate)
        : model != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(model.date)
            : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết giao dịch'),
        actions: item == null && model == null
            ? null
            : [
                IconButton(
                  tooltip: 'Xóa giao dịch',
                  onPressed: _isDeleting
                      ? null
                      : () async {
                          if (item != null) {
                            await _deleteTransaction(item);
                          } else if (model != null) {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Xóa giao dịch'),
                                  content: const Text(
                                    'Bạn có chắc muốn xóa giao dịch này không?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Hủy'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Xóa'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed != true) {
                              return;
                            }

                            setState(() {
                              _isDeleting = true;
                            });

                            try {
                              await context
                                  .read<TransactionProvider>()
                                  .deleteTransaction(model.id);
                              if (!mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã xóa giao dịch'),
                                ),
                              );
                            } catch (_) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Xóa giao dịch thất bại, vui lòng thử lại',
                                  ),
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isDeleting = false;
                                });
                              }
                            }
                          }
                        },
                  icon: _isDeleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline),
                ),
              ],
      ),
      body: item == null && model == null
          ? const Center(child: Text('Không có dữ liệu giao dịch'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số tiền',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currency.format(
                            item != null
                                ? item.amount
                                : model != null
                                    ? model.amount
                                    : 0,
                          ),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Loại'),
                        subtitle: Text(
                          (item != null && item.type == 'expense') ||
                                  (model != null && !model.isIncome)
                              ? 'Chi tiêu'
                              : 'Thu nhập',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Danh mục'),
                        subtitle: Text(
                          item?.category ?? model?.categoryName ?? '',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Ghi chú'),
                        subtitle: Text(
                          item != null
                              ? (item.note.isEmpty
                                  ? 'Không có ghi chú'
                                  : item.note)
                              : (model != null
                                      ? (model.note == null ||
                                              model.note!.trim().isEmpty
                                          ? 'Không có ghi chú'
                                          : model.note!)
                                      : 'Không có ghi chú'),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Ngày giao dịch'),
                        subtitle: Text(dateText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
