import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
import 'package:expense_tracker_app/shared/models/category_item.dart';
import 'package:flutter/material.dart';

class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({super.key});

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _dataService = FirestoreDataService();

  String _type = 'expense';
  String? _selectedCategoryId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(List<CategoryItem> categories) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final selectedCategory = categories.firstWhere(
      (item) => item.id == _selectedCategoryId,
      orElse: () => categories.first,
    );

    final parsedAmount = double.tryParse(_amountController.text.trim());
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Số tiền không hợp lệ')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _dataService.createTransaction(
        type: _type,
        category: selectedCategory,
        amount: parsedAmount,
        note: _noteController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã lưu giao dịch')));
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu giao dịch thất bại, vui lòng thử lại'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm giao dịch')),
      body: StreamBuilder<List<CategoryItem>>(
        stream: _dataService.watchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allCategories = snapshot.data ?? const [];
          final categories = allCategories
              .where((item) => item.type == _type)
              .toList(growable: false);

          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'Không có danh mục phù hợp. Vui lòng tạo danh mục trước.',
              ),
            );
          }

          if (_selectedCategoryId == null ||
              !categories.any((item) => item.id == _selectedCategoryId)) {
            _selectedCategoryId = categories.first.id;
          }

          return Form(
            key: _formKey,
            child: ListView(
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
                            ButtonSegment(value: 'expense', label: Text('Chi')),
                            ButtonSegment(value: 'income', label: Text('Thu')),
                          ],
                          selected: {_type},
                          onSelectionChanged: (values) {
                            setState(() {
                              _type = values.first;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategoryId,
                          items: categories
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Danh mục',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Số tiền',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập số tiền';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _noteController,
                          decoration: const InputDecoration(
                            labelText: 'Ghi chú',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : () => _submit(categories),
                  icon: _isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_isSubmitting ? 'Đang lưu...' : 'Lưu giao dịch'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
