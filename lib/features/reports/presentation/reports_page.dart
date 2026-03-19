import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );

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
                SizedBox(height: 8),
                const _PercentBar(label: 'Ăn uống', percent: 0.35),
                const SizedBox(height: 6),
                const _PercentBar(label: 'Đi lại', percent: 0.15),
                const SizedBox(height: 6),
                const _PercentBar(label: 'Khác', percent: 0.50),
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
                SizedBox(height: 8),
                _MonthlyRow(label: 'Tháng 1', value: currency.format(2200000)),
                _MonthlyRow(label: 'Tháng 2', value: currency.format(3100000)),
                _MonthlyRow(label: 'Tháng 3', value: currency.format(1500000)),
              ],
            ),
          ),
        ),
      ],
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
