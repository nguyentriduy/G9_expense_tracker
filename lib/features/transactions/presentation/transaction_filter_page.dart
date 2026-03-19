import 'package:expense_tracker_app/core/localization/app_localization.dart';
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
      appBar: AppBar(title: Text(context.t('search_filter'))),
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
                    context.t('transaction_type'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
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
                    ],
                    onChanged: (value) {
                      setState(() {
                        _category = value ?? 'all';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: context.t('category'),
                    ),
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
              child: Text(context.t('apply_filter')),
            ),
          ),
        ],
      ),
    );
  }
}
