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
      appBar: AppBar(title: const Text('Tìm kiếm và lọc')),
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
                    'Loại giao dịch',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'all', label: Text('Tất cả')),
                      ButtonSegment(value: 'expense', label: Text('Chi')),
                      ButtonSegment(value: 'income', label: Text('Thu')),
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
                    ],
                    onChanged: (value) {
                      setState(() {
                        _category = value ?? 'all';
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Danh mục'),
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
              child: const Text('Áp dụng bộ lọc'),
            ),
          ),
        ],
      ),
    );
  }
}
