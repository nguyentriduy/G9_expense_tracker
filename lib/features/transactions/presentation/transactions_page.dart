import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
=======
>>>>>>> origin/feature/categories
=======
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
>>>>>>> origin/feature/dashboard
import 'package:expense_tracker_app/shared/models/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/feature/dashboard
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
        ? 'MM/dd/yyyy'
        : 'dd/MM/yyyy';
    final dateFormat = DateFormat(datePattern);
<<<<<<< HEAD
=======
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd/MM/yyyy');
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
    final dataService = FirestoreDataService();

    return StreamBuilder<List<TransactionItem>>(
      stream: dataService.watchTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
<<<<<<< HEAD
<<<<<<< HEAD
          return Center(child: Text(context.t('no_transactions')));
=======
          return const Center(child: Text('Chưa có giao dịch nào'));
>>>>>>> origin/feature/categories
=======
          return Center(child: Text(context.t('no_transactions')));
>>>>>>> origin/feature/dashboard
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemBuilder: (context, index) {
            final item = items[index];
            final isExpense = item.type == 'expense';
            final amountColor = isExpense
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary;

            return Dismissible(
              key: ValueKey(item.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              confirmDismiss: (direction) async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
<<<<<<< HEAD
<<<<<<< HEAD
                      title: Text(context.t('delete_transaction')),
                      content: Text(context.t('delete_confirm')),
=======
                      title: const Text('Xóa giao dịch'),
                      content: const Text(
                        'Bạn có chắc muốn xóa giao dịch này không?',
                      ),
>>>>>>> origin/feature/categories
=======
                      title: Text(context.t('delete_transaction')),
                      content: Text(context.t('delete_confirm')),
>>>>>>> origin/feature/dashboard
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
<<<<<<< HEAD
<<<<<<< HEAD
                          child: Text(context.t('cancel')),
=======
                          child: const Text('Hủy'),
>>>>>>> origin/feature/categories
=======
                          child: Text(context.t('cancel')),
>>>>>>> origin/feature/dashboard
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },
<<<<<<< HEAD
<<<<<<< HEAD
                          child: Text(context.t('delete')),
=======
                          child: const Text('Xóa'),
>>>>>>> origin/feature/categories
=======
                          child: Text(context.t('delete')),
>>>>>>> origin/feature/dashboard
                        ),
                      ],
                    );
                  },
                );

                if (confirmed != true) {
                  return false;
                }

                try {
                  await dataService.deleteTransaction(item.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
<<<<<<< HEAD
                      SnackBar(content: Text(context.t('delete_success'))),
=======
                      const SnackBar(content: Text('Đã xóa giao dịch')),
>>>>>>> origin/feature/categories
=======
                      SnackBar(content: Text(context.t('delete_success'))),
>>>>>>> origin/feature/dashboard
                    );
                  }
                  return true;
                } on StateError catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message)));
                  }
                  return false;
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
<<<<<<< HEAD
                      SnackBar(content: Text(context.t('delete_failed'))),
=======
                      const SnackBar(
                        content: Text(
                          'Xóa giao dịch thất bại, vui lòng thử lại',
                        ),
                      ),
>>>>>>> origin/feature/categories
=======
                      SnackBar(content: Text(context.t('delete_failed'))),
>>>>>>> origin/feature/dashboard
                    );
                  }
                  return false;
                }
              },
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: amountColor.withValues(alpha: 0.14),
                    child: Icon(
                      isExpense
                          ? Icons.south_west_rounded
                          : Icons.north_east_rounded,
                      color: amountColor,
                    ),
                  ),
                  title: Text(
                    item.category,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${item.note} • ${dateFormat.format(item.transactionDate)}',
                  ),
                  trailing: Text(
                    '${isExpense ? '-' : '+'}${currency.format(item.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.transactionDetail,
                      arguments: item,
                    );
                  },
                ),
              ),
            );
          },
          separatorBuilder: (_, index) => const SizedBox(height: 10),
          itemCount: items.length,
        );
      },
    );
  }
}
