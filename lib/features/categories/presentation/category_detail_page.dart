import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
import 'package:expense_tracker_app/shared/models/category_item.dart';
import 'package:expense_tracker_app/shared/models/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryDetailPage extends StatelessWidget {
  const CategoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)?.settings.arguments as CategoryItem?;
    final dataService = FirestoreDataService();
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết danh mục')),
      body: category == null
          ? const Center(child: Text('Không có dữ liệu danh mục'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: category.color.withValues(alpha: 0.16),
                      child: Icon(category.icon, color: category.color),
                    ),
                    title: Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      category.type == 'expense'
                          ? 'Danh mục chi tiêu'
                          : 'Danh mục thu nhập',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<List<TransactionItem>>(
                  stream: dataService.watchTransactionsByCategory(category.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          title: const Text(
                            'Không tải được giao dịch danh mục',
                          ),
                          subtitle: const Text(
                            'Vui lòng thử lại sau hoặc kiểm tra cấu hình dữ liệu.',
                          ),
                        ),
                      );
                    }

                    final transactions = snapshot.data ?? const [];
                    final totalAmount = transactions.fold<double>(
                      0,
                      (sum, item) => sum + item.amount,
                    );
                    final dateFormat = DateFormat('dd/MM/yyyy');

                    return Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.payments_outlined),
                                title: const Text('Tổng số giao dịch'),
                                subtitle: Text(
                                  '${transactions.length} giao dịch',
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                leading: const Icon(Icons.analytics_outlined),
                                title: const Text('Tổng số tiền'),
                                subtitle: Text(currency.format(totalAmount)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Giao dịch thuộc danh mục',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (transactions.isEmpty)
                          const Card(
                            child: ListTile(
                              title: Text('Chưa có giao dịch nào'),
                            ),
                          )
                        else
                          ...transactions.map((item) {
                            final isExpense = item.type == 'expense';
                            final amountColor = isExpense
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    item.note.isEmpty
                                        ? category.name
                                        : item.note,
                                  ),
                                  subtitle: Text(
                                    dateFormat.format(item.transactionDate),
                                  ),
                                  trailing: Text(
                                    '${isExpense ? '-' : '+'}${currency.format(item.amount)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: amountColor,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.transactionDetail,
                                      arguments: item,
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
