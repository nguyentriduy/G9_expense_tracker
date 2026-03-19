import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
=======
>>>>>>> origin/feature/categories
=======
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
>>>>>>> origin/feature/dashboard
=======
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
>>>>>>> parent of 8a88830 (merge categories)
import 'package:expense_tracker_app/shared/models/category_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = FirestoreDataService();
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/feature/dashboard
=======
>>>>>>> parent of 8a88830 (merge categories)
    final prefs = AppPreferencesScope.of(context);
    final locale = switch (prefs.languageCode) {
      'en' => 'en_US',
      'ja' => 'ja_JP',
      _ => 'vi_VN',
    };
    final currency = NumberFormat.currency(
      locale: locale,
      symbol: prefs.currencyCode,
      decimalDigits: 0,
    );
    final datePattern = prefs.languageCode == 'en'
        ? 'MM/dd/yyyy'
        : 'dd/MM/yyyy';
    final dateFormat = DateFormat(datePattern);
<<<<<<< HEAD
<<<<<<< HEAD
=======
    final currency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VND',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd/MM/yyyy');
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
=======
>>>>>>> parent of 8a88830 (merge categories)

    return StreamBuilder<List<CategoryItem>>(
      stream: dataService.watchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data ?? const [];
        if (categories.isEmpty) {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
          return Center(child: Text(context.t('no_categories')));
=======
          return const Center(child: Text('Chưa có danh mục nào'));
>>>>>>> origin/feature/categories
=======
          return Center(child: Text(context.t('no_categories')));
>>>>>>> origin/feature/dashboard
=======
          return Center(child: Text(context.t('no_categories')));
>>>>>>> parent of 8a88830 (merge categories)
        }

        return StreamBuilder<Map<String, CategoryTransactionStats>>(
          stream: dataService.watchCategoryTransactionStats(),
          builder: (context, statsSnapshot) {
            final statsMap = statsSnapshot.data ?? const {};

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                Text(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                  context.t('income_expense_categories'),
=======
                  'Danh mục thu chi',
>>>>>>> origin/feature/categories
=======
                  context.t('income_expense_categories'),
>>>>>>> origin/feature/dashboard
=======
                  context.t('income_expense_categories'),
>>>>>>> parent of 8a88830 (merge categories)
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ...categories.map((category) {
                  final stats = statsMap[category.id];
                  final amountColor = category.type == 'expense'
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary;

                  final subtitleText = stats == null
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> origin/feature/dashboard
=======
>>>>>>> parent of 8a88830 (merge categories)
                      ? '${category.type == 'expense' ? context.t('expense') : context.t('income')} • ${context.t('no_activity')}'
                      : '${category.type == 'expense' ? context.t('expense') : context.t('income')} • ${context.t('transactions_count', {'count': stats.count.toString()})}';

                  final trailingInfo = stats == null
                      ? '0 ${prefs.currencyCode}'
<<<<<<< HEAD
<<<<<<< HEAD
=======
                      ? '${category.type == 'expense' ? 'Chi tiêu' : 'Thu nhập'} • Chưa có giao dịch'
                      : '${category.type == 'expense' ? 'Chi tiêu' : 'Thu nhập'} • ${stats.count} giao dịch';

                  final trailingInfo = stats == null
                      ? '0 VND'
>>>>>>> origin/feature/categories
=======
>>>>>>> origin/feature/dashboard
=======
>>>>>>> parent of 8a88830 (merge categories)
                      : currency.format(stats.totalAmount);
                  final lastDate = stats?.lastTransactionDate;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: category.color.withValues(
                            alpha: 0.15,
                          ),
                          child: Icon(category.icon, color: category.color),
                        ),
                        title: Text(category.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(subtitleText),
                            if (lastDate != null)
                              Text(
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
                                context.t('latest', {
                                  'date': dateFormat.format(lastDate),
                                }),
=======
                                'Gần nhất: ${dateFormat.format(lastDate)}',
>>>>>>> origin/feature/categories
=======
                                context.t('latest', {
                                  'date': dateFormat.format(lastDate),
                                }),
>>>>>>> origin/feature/dashboard
=======
                                context.t('latest', {
                                  'date': dateFormat.format(lastDate),
                                }),
>>>>>>> parent of 8a88830 (merge categories)
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              trailingInfo,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: amountColor,
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.categoryDetail,
                            arguments: category,
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
