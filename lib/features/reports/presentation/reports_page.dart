import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:expense_tracker_app/providers/transaction_provider.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );

    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final transactions = provider.allTransactions;
        final expenses =
            transactions.where((tx) => !tx.isIncome).toList(growable: false);

        // Category distribution
        final Map<String, int> categoryTotals = {};
        for (final tx in expenses) {
          final key = tx.categoryName;
          categoryTotals[key] = (categoryTotals[key] ?? 0) + tx.amount;
        }
        final totalExpense =
            categoryTotals.values.fold<int>(0, (sum, v) => sum + v);

        final categoryEntries = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topCategories = categoryEntries.take(5).toList();

        // Monthly totals (by month/year)
        final Map<DateTime, int> monthTotals = {};
        for (final tx in expenses) {
          final key = DateTime(tx.date.year, tx.date.month);
          monthTotals[key] = (monthTotals[key] ?? 0) + tx.amount;
        }
        final monthEntries = monthTotals.entries.toList()
          ..sort((a, b) => b.key.compareTo(a.key));
        final topMonths = monthEntries.take(3).toList();

        final monthFormat = DateFormat('MM/yyyy');

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            Text(
              'Phân tích chi tiêu',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thống kê theo danh mục',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (totalExpense == 0)
                      const Text('Chưa có dữ liệu chi tiêu')
                    else ...[
                      for (final entry in topCategories) ...[
                        _PercentBar(
                          label: entry.key,
                          percent: entry.value / totalExpense,
                        ),
                        const SizedBox(height: 6),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thống kê theo tháng',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (topMonths.isEmpty)
                      const Text('Chưa có dữ liệu theo tháng')
                    else ...[
                      for (final entry in topMonths)
                        _MonthlyRow(
                          label: monthFormat.format(entry.key),
                          value: currency.format(entry.value),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PercentBar extends StatelessWidget {
  const _PercentBar({required this.label, required this.percent});

  final String label;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text('${(percent * 100).round()}%')],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent,
          borderRadius: BorderRadius.circular(8),
          minHeight: 8,
        ),
      ],
    );
  }
}

class _MonthlyRow extends StatelessWidget {
  const _MonthlyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
