import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_empty_state.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_list_section.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  DateTime? _tempFromDate;
  DateTime? _tempToDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickFromDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempFromDate ?? context.read<TransactionProvider>().fromDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _tempFromDate = picked;
      });
    }
  }

  Future<void> _pickToDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tempToDate ?? context.read<TransactionProvider>().toDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _tempToDate = picked;
      });
    }
  }

  void _applyQuery() {
    final provider = context.read<TransactionProvider>();
    provider.setFilter(
      from: _tempFromDate,
      to: _tempToDate,
    );
  }

  Future<void> _openAddTransactionScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddTransactionScreen(),
      ),
    );
  }

  void _onSearchChanged() {
    context
        .read<TransactionProvider>()
        .setSearchKeyword(_searchController.text.trim());
  }

  Future<void> _editTransaction(TransactionModel tx) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(initialTransaction: tx),
      ),
    );
  }

  Future<void> _deleteTransaction(TransactionModel tx) async {
    await context.read<TransactionProvider>().deleteTransaction(tx.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final groups = provider.groupedByDate;
    Widget body;

    if (provider.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (provider.errorMessage != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(provider.errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => provider.loadFromLocal(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    } else if (groups.isEmpty) {
      body = const TransactionEmptyState();
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return TransactionListSection(
            group: groups[index],
            onTapTransaction: _editTransaction,
            onDeleteTransaction: _deleteTransaction,
          );
        },
      );
    }

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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm giao dịch...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFF0F1822),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _TypeFilterBar(provider: provider),
              ],
            ),
          ),
          TransactionFilterBar(
            fromDate: _tempFromDate ?? provider.fromDate,
            toDate: _tempToDate ?? provider.toDate,
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
        backgroundColor: const Color(0xFF1ABC9C),
        icon: const Icon(Icons.add),
        label: const Text('Thêm giao dịch'),
      ),
    );
  }
}

class _TypeFilterBar extends StatelessWidget {
  const _TypeFilterBar({required this.provider});

  final TransactionProvider provider;

  @override
  Widget build(BuildContext context) {
    final current = provider.kindFilter;

    Widget buildChip(String label, TransactionKindFilter value) {
      final selected = current == value;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => provider.setKindFilter(value),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildChip('Tất cả', TransactionKindFilter.all),
        const SizedBox(width: 8),
        buildChip('Chỉ Thu', TransactionKindFilter.income),
        const SizedBox(width: 8),
        buildChip('Chỉ Chi', TransactionKindFilter.expense),
      ],
    );
  }
}
