import 'package:expense_tracker_app/app/app_router.dart';
import 'package:expense_tracker_app/core/firebase/firestore_data_service.dart';
import 'package:expense_tracker_app/core/localization/app_localization.dart';
import 'package:expense_tracker_app/core/settings/app_preferences_scope.dart';
import 'package:expense_tracker_app/shared/models/category_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = FirestoreDataService();
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

    return StreamBuilder<List<CategoryItem>>(
      stream: dataService.watchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = snapshot.data ?? const [];
        if (categories.isEmpty) {
          return Center(child: Text(context.t('no_categories')));
        }

        return StreamBuilder<Map<String, CategoryTransactionStats>>(
          stream: dataService.watchCategoryTransactionStats(),
          builder: (context, statsSnapshot) {
            final statsMap = statsSnapshot.data ?? const {};

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                Text(
                  context.t('income_expense_categories'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ...categories.map((category) {
                  final stats = statsMap[category.id];
                  final amountColor = category.type == 'expense'
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary;

                  final subtitleText = stats == null
                      ? '${category.type == 'expense' ? context.t('expense') : context.t('income')} • ${context.t('no_activity')}'
                      : '${category.type == 'expense' ? context.t('expense') : context.t('income')} • ${context.t('transactions_count', {'count': stats.count.toString()})}';

                  final trailingInfo = stats == null
                      ? '0 ${prefs.currencyCode}'
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
                                context.t('latest', {
                                  'date': dateFormat.format(lastDate),
                                }),
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
