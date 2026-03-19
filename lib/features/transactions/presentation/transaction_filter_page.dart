<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
=======
>>>>>>> origin/feature/categories
import 'package:flutter/material.dart';

class TransactionFilterPage extends StatefulWidget {
  const TransactionFilterPage({super.key});

  @override
  State<TransactionFilterPage> createState() => _TransactionFilterPageState();
}

class _TransactionFilterPageState extends State<TransactionFilterPage> {
  String _type = 'all';
  String _category = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: Text(context.t('search_filter'))),
=======
      appBar: AppBar(title: const Text('Tìm kiếm và lọc')),
>>>>>>> origin/feature/categories
      body: ListView(
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
                    context.t('transaction_type'),
=======
                    'Loại giao dịch',
>>>>>>> origin/feature/categories
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
<<<<<<< HEAD
                    segments: [
                      ButtonSegment(
                        value: 'all',
                        label: Text(context.t('all')),
                      ),
                      ButtonSegment(
                        value: 'expense',
                        label: Text(context.t('expense_short')),
                      ),
                      ButtonSegment(
                        value: 'income',
                        label: Text(context.t('income_short')),
                      ),
=======
                    segments: const [
                      ButtonSegment(value: 'all', label: Text('Tất cả')),
                      ButtonSegment(value: 'expense', label: Text('Chi')),
                      ButtonSegment(value: 'income', label: Text('Thu')),
>>>>>>> origin/feature/categories
                    ],
                    selected: {_type},
                    onSelectionChanged: (value) {
                      setState(() {
                        _type = value.first;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
<<<<<<< HEAD
                    items: [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text(context.t('all_categories')),
                      ),
                      DropdownMenuItem(
                        value: 'food',
                        child: Text(context.t('food')),
                      ),
                      DropdownMenuItem(
                        value: 'transport',
                        child: Text(context.t('transport')),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(context.t('other')),
                      ),
=======
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('Tất cả danh mục'),
                      ),
                      DropdownMenuItem(
                        value: 'Ăn uống',
                        child: Text('Ăn uống'),
                      ),
                      DropdownMenuItem(value: 'Đi lại', child: Text('Đi lại')),
                      DropdownMenuItem(value: 'Lương', child: Text('Lương')),
>>>>>>> origin/feature/categories
                    ],
                    onChanged: (value) {
                      setState(() {
                        _category = value ?? 'all';
                      });
                    },
<<<<<<< HEAD
                    decoration: InputDecoration(
                      labelText: context.t('category'),
                    ),
=======
                    decoration: const InputDecoration(labelText: 'Danh mục'),
>>>>>>> origin/feature/categories
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
<<<<<<< HEAD
              child: Text(context.t('apply_filter')),
=======
              child: const Text('Áp dụng bộ lọc'),
>>>>>>> origin/feature/categories
            ),
          ),
        ],
      ),
    );
  }
}
