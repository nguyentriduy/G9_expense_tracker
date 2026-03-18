import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
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
      ).showSnackBar(SnackBar(content: Text(context.t('delete_success'))));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('delete_failed'))));
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
        actions: item == null
            ? null
            : [
                IconButton(
                  tooltip: context.t('delete_transaction'),
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
          ? Center(child: Text(context.t('no_transaction_data')))
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
                          context.t('amount'),
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
                        title: Text(context.t('type')),
                        subtitle: Text(
                          item.type == 'expense'
                              ? context.t('expense')
                              : context.t('income'),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text(context.t('category')),
                        subtitle: Text(item.category),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text(context.t('note')),
                        subtitle: Text(
                          item.note.isEmpty ? context.t('no_note') : item.note,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text(context.t('transaction_date')),
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
