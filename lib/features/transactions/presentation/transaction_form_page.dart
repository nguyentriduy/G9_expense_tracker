import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
=======
>>>>>>> origin/feature/categories
=======
import 'package:expense_tracker_app/core/localization/app_localization.dart';
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
      ).showSnackBar(SnackBar(content: Text(context.t('invalid_amount'))));
=======
      ).showSnackBar(const SnackBar(content: Text('Số tiền không hợp lệ')));
>>>>>>> origin/feature/categories
=======
      ).showSnackBar(SnackBar(content: Text(context.t('invalid_amount'))));
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
      ).showSnackBar(SnackBar(content: Text(context.t('transaction_saved'))));
=======
      ).showSnackBar(const SnackBar(content: Text('Đã lưu giao dịch')));
>>>>>>> origin/feature/categories
=======
      ).showSnackBar(SnackBar(content: Text(context.t('transaction_saved'))));
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('save_failed'))));
=======
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu giao dịch thất bại, vui lòng thử lại'),
        ),
      );
>>>>>>> origin/feature/categories
=======
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t('save_failed'))));
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
      appBar: AppBar(title: Text(context.t('add_transaction'))),
=======
      appBar: AppBar(title: const Text('Thêm giao dịch')),
>>>>>>> origin/feature/categories
=======
      appBar: AppBar(title: Text(context.t('add_transaction'))),
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
            return Center(child: Text(context.t('no_matching_category')));
=======
            return const Center(
              child: Text(
                'Không có danh mục phù hợp. Vui lòng tạo danh mục trước.',
              ),
            );
>>>>>>> origin/feature/categories
=======
            return Center(child: Text(context.t('no_matching_category')));
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
                          context.t('transaction_type'),
=======
                          'Loại giao dịch',
>>>>>>> origin/feature/categories
=======
                          context.t('transaction_type'),
>>>>>>> origin/feature/dashboard
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        SegmentedButton<String>(
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/feature/dashboard
                          segments: [
                            ButtonSegment(
                              value: 'expense',
                              label: Text(context.t('expense_short')),
                            ),
                            ButtonSegment(
                              value: 'income',
                              label: Text(context.t('income_short')),
                            ),
<<<<<<< HEAD
=======
                          segments: const [
                            ButtonSegment(value: 'expense', label: Text('Chi')),
                            ButtonSegment(value: 'income', label: Text('Thu')),
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
                          decoration: InputDecoration(
                            labelText: context.t('category'),
=======
                          decoration: const InputDecoration(
                            labelText: 'Danh mục',
>>>>>>> origin/feature/categories
=======
                          decoration: InputDecoration(
                            labelText: context.t('category'),
>>>>>>> origin/feature/dashboard
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/feature/dashboard
                          decoration: InputDecoration(
                            labelText: context.t('amount'),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.t('enter_amount');
<<<<<<< HEAD
=======
                          decoration: const InputDecoration(
                            labelText: 'Số tiền',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập số tiền';
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _noteController,
<<<<<<< HEAD
<<<<<<< HEAD
                          decoration: InputDecoration(
                            labelText: context.t('note'),
=======
                          decoration: const InputDecoration(
                            labelText: 'Ghi chú',
>>>>>>> origin/feature/categories
=======
                          decoration: InputDecoration(
                            labelText: context.t('note'),
>>>>>>> origin/feature/dashboard
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
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/feature/dashboard
                  label: Text(
                    _isSubmitting
                        ? context.t('saving')
                        : context.t('save_transaction'),
                  ),
<<<<<<< HEAD
=======
                  label: Text(_isSubmitting ? 'Đang lưu...' : 'Lưu giao dịch'),
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
