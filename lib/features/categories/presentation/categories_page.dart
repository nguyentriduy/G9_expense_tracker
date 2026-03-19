import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
import 'package:expense_tracker_app/shared/models/category_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:expense_tracker_app/providers/transaction_provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = FirestoreDataService();
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd/MM/yyyy');

    return StreamBuilder<List<CategoryItem>>(
      stream: dataService.watchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data ?? const [];
        if (categories.isEmpty) {
          return const Center(child: Text('Chưa có danh mục nào'));
        }

        return Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            final transactions = provider.allTransactions;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                Text(
                  'Danh mục thu chi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ...categories.map((category) {
                  final relevant = transactions.where((tx) {
                    final sameCategory = tx.categoryName == category.name;
                    final sameType =
                        (category.type == 'expense' && !tx.isIncome) ||
                        (category.type == 'income' && tx.isIncome);
                    return sameCategory && sameType;
                  }).toList();

                  final count = relevant.length;
                  final totalAmount = relevant.fold<int>(
                    0,
                    (sum, tx) => sum + tx.amount,
                  );
                  DateTime? lastDate;
                  if (relevant.isNotEmpty) {
                    lastDate = relevant
                        .map((tx) => tx.date)
                        .reduce((a, b) => a.isAfter(b) ? a : b);
                  }

                  final amountColor = category.type == 'expense'
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary;

                  final subtitleText = count == 0
                      ? '${category.type == 'expense' ? 'Chi tiêu' : 'Thu nhập'} • Chưa có giao dịch'
                      : '${category.type == 'expense' ? 'Chi tiêu' : 'Thu nhập'} • $count giao dịch';

                  final trailingInfo =
                      count == 0 ? '0 VND' : currency.format(totalAmount);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: category.color.withValues(
                            alpha: 0.15,
                          ),
                          child: Icon(category.icon, color: category.color),
                        ),
                        title: Text(category.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(subtitleText),
                            if (lastDate != null)
                              Text(
                                'Gần nhất: ${dateFormat.format(lastDate)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              trailingInfo,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: amountColor,
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.categoryDetail,
                            arguments: category,
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
