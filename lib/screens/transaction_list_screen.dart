import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../widgets/transaction_empty_state.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_list_section.dart';
import 'add_transaction_screen.dart';

/// Màn hình Tab "Giao dịch" hiển thị danh sách giao dịch đã group theo ngày.
class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  DateTime? _tempFromDate;
  DateTime? _tempToDate;

  Future<void> _pickFromDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempFromDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _tempFromDate = picked);
    }
  }

  Future<void> _pickToDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempToDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _tempToDate = picked);
    }
  }

  void _applyQuery() {
    context.read<TransactionProvider>().setFilter(
          from: _tempFromDate,
          to: _tempToDate,
        );
  }

  Future<void> _openAddTransactionScreen() async {
    final result = await Navigator.of(context).pushNamed(
      AddTransactionScreen.routeName,
    );

    if (result != null && result is! bool) {
      // Màn hình Add trả về TransactionModel, provider sẽ xử lý trong add từ đó.
      // Ở đây ta chỉ cần gọi notify thông qua provider nếu cần thiết.
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final groups = provider.groupedByDate;

    final body = groups.isEmpty
        ? const TransactionEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return TransactionListSection(group: groups[index]);
            },
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao dịch'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          TransactionFilterBar(
            fromDate: provider.fromDate,
            toDate: provider.toDate,
            onSelectFromDate: _pickFromDate,
            onSelectToDate: _pickToDate,
            onQuery: _applyQuery,
          ),
          Expanded(child: body),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTransactionScreen,
        backgroundColor: const Color(0xFF1ABC9C), // xanh ngọc
        icon: const Icon(Icons.add),
        label: const Text('Thêm giao dịch'),
      ),
    );
  }
}
