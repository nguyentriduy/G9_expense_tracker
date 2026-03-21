import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../shared/models/transaction_model.dart';
import '../../../providers/transaction_provider.dart';
import '../../../widgets/thousand_separator_input_formatter.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, this.initialTransaction});

  static const routeName = '/add-transaction';

  final TransactionModel? initialTransaction;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isIncome = false;
  String? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<String> _expenseCategories = [
    'Ăn uống',
    'Mua sắm',
    'Đi lại',
    'Giải trí',
    'Khác',
  ];

  final List<String> _incomeCategories = [
    'Lương',
    'Thưởng',
    'Khác',
  ];

  List<String> get _currentCategories =>
      _isIncome ? _incomeCategories : _expenseCategories;

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;

    if (tx != null) {
      _isIncome = tx.isIncome;

      final currentCategories = _currentCategories;
      if (!currentCategories.contains(tx.categoryName)) {
        currentCategories.insert(0, tx.categoryName);
      }
      _selectedCategory = tx.categoryName;

      final formatter = NumberFormat.decimalPattern('vi_VN');
      _amountController.text = formatter.format(tx.amount);
      _noteController.text = tx.note ?? '';
    } else {
      _selectedCategory = _currentCategories.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int _parseAmount(String text) {
    final cleaned = text.replaceAll('.', '').replaceAll(',', '').trim();
    if (cleaned.isEmpty) return 0;
    return int.tryParse(cleaned) ?? 0;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = _parseAmount(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
      );
      return;
    }

    final isEditing = widget.initialTransaction != null;
    final base = widget.initialTransaction;

    final tx = TransactionModel(
      id: isEditing
          ? base!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      isIncome: _isIncome,
      categoryName: _selectedCategory ?? '',
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      date: isEditing ? base!.date : DateTime.now(),
    );

    final provider = context.read<TransactionProvider>();
    if (isEditing) {
      await provider.updateTransaction(tx);
    } else {
      await provider.addTransaction(tx);
    }

    Navigator.of(context).pop(tx);
  }

  @override
  Widget build(BuildContext context) {
		final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialTransaction == null
              ? 'Thêm giao dịch'
              : 'Sửa giao dịch',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
						color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loại giao dịch',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _SegmentButton(
                            label: 'Chi',
                            isSelected: !_isIncome,
                            onTap: () {
                              setState(() {
                                _isIncome = false;
                                _selectedCategory = _expenseCategories.first;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          _SegmentButton(
                            label: 'Thu',
                            isSelected: _isIncome,
                            onTap: () {
                              setState(() {
                                _isIncome = true;
                                _selectedCategory = _incomeCategories.first;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Danh mục',
                          border: OutlineInputBorder(),
                        ),
                        items: _currentCategories
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          ThousandSeparatorInputFormatter(
                            locale: 'vi_VN',
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Số tiền',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Số tiền không được để trống';
                          }
                          if (_parseAmount(value) <= 0) {
                            return 'Số tiền phải lớn hơn 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          labelText: 'Ghi chú',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
							backgroundColor: colorScheme.primary,
							foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Lưu giao dịch'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF1ABC9C);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isSelected ? teal.withOpacity(0.25) : Colors.transparent,
            border: Border.all(color: teal),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              if (isSelected) const SizedBox(width: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
