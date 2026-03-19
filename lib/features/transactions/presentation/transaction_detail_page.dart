import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
=======
>>>>>>> origin/feature/categories
import 'package:expense_tracker_app/shared/models/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
<<<<<<< HEAD
          title: Text(context.t('delete_transaction')),
          content: Text(context.t('delete_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.t('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.t('delete')),
=======
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
>>>>>>> origin/feature/categories
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
<<<<<<< HEAD
      ).showSnackBar(SnackBar(content: Text(context.t('delete_success'))));
=======
      ).showSnackBar(const SnackBar(content: Text('Đã xóa giao dịch')));
>>>>>>> origin/feature/categories
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
<<<<<<< HEAD
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('delete_failed'))));
=======
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa giao dịch thất bại, vui lòng thử lại'),
        ),
      );
>>>>>>> origin/feature/categories
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
    final item = ModalRoute.of(context)?.settings.arguments as TransactionItem?;
<<<<<<< HEAD
    final prefs = AppPreferencesScope.of(context);
    final locale = switch (prefs.languageCode) {
      'en' => 'en_US',
      'ja' => 'ja_JP',
      _ => 'vi_VN',
    };
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: prefs.currencyCode,
      decimalDigits: 0,
    );
    final datePattern = prefs.languageCode == 'en'
        ? 'MM/dd/yyyy HH:mm'
        : 'dd/MM/yyyy HH:mm';
    final dateText = item == null
        ? ''
        : DateFormat(datePattern).format(item.transactionDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('transaction_detail')),
=======
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );
    final dateText = item == null
        ? ''
        : DateFormat('dd/MM/yyyy HH:mm').format(item.transactionDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết giao dịch'),
>>>>>>> origin/feature/categories
        actions: item == null
            ? null
            : [
                IconButton(
<<<<<<< HEAD
                  tooltip: context.t('delete_transaction'),
=======
                  tooltip: 'Xóa giao dịch',
>>>>>>> origin/feature/categories
                  onPressed: _isDeleting
                      ? null
                      : () => _deleteTransaction(item),
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
      body: item == null
<<<<<<< HEAD
          ? Center(child: Text(context.t('no_transaction_data')))
=======
          ? const Center(child: Text('Không có dữ liệu giao dịch'))
>>>>>>> origin/feature/categories
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
<<<<<<< HEAD
                          context.t('amount'),
=======
                          'Số tiền',
>>>>>>> origin/feature/categories
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currency.format(item.amount),
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
<<<<<<< HEAD
                        title: Text(context.t('type')),
                        subtitle: Text(
                          item.type == 'expense'
                              ? context.t('expense')
                              : context.t('income'),
=======
                        title: const Text('Loại'),
                        subtitle: Text(
                          item.type == 'expense' ? 'Chi tiêu' : 'Thu nhập',
>>>>>>> origin/feature/categories
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
<<<<<<< HEAD
                        title: Text(context.t('category')),
=======
                        title: const Text('Danh mục'),
>>>>>>> origin/feature/categories
                        subtitle: Text(item.category),
                      ),
                      const Divider(height: 1),
                      ListTile(
<<<<<<< HEAD
                        title: Text(context.t('note')),
                        subtitle: Text(
                          item.note.isEmpty ? context.t('no_note') : item.note,
=======
                        title: const Text('Ghi chú'),
                        subtitle: Text(
                          item.note.isEmpty ? 'Không có ghi chú' : item.note,
>>>>>>> origin/feature/categories
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
<<<<<<< HEAD
                        title: Text(context.t('transaction_date')),
=======
                        title: const Text('Ngày giao dịch'),
>>>>>>> origin/feature/categories
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
