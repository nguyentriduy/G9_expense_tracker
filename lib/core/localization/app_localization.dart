import 'package:flutter/widgets.dart';

extension AppLocalizationX on BuildContext {
  String t(String key, [Map<String, String> params = const {}]) {
    final languageCode =
        Localizations.maybeLocaleOf(this)?.languageCode ?? 'vi';
    final template =
        _localizedValues[languageCode]?[key] ??
        _localizedValues['vi']?[key] ??
        _humanizeKey(key);

    if (params.isEmpty) {
      return template;
    }

    var result = template;
    for (final entry in params.entries) {
      result = result
          .replaceAll('{${entry.key}}', entry.value)
          .replaceAll(':${entry.key}', entry.value);
    }
    return result;
  }
}

String _humanizeKey(String key) {
  final words = key.split('_').where((word) => word.isNotEmpty).toList();
  if (words.isEmpty) {
    return key;
  }
  final sentence = words.join(' ');
  return sentence[0].toUpperCase() + sentence.substring(1);
}

const Map<String, Map<String, String>> _localizedValues = {
  'vi': {
    'app_title': 'Expense Tracker',
    'app_tagline': 'Track money with clarity',
    'login': 'Login',
    'register_now': 'Register now',
    'forgot_password': 'Forgot password',
    'create_account': 'Create account',
    'send_request': 'Send request',
    'save_transaction': 'Save transaction',
    'delete_transaction': 'Delete transaction',
    'delete_confirm': 'Are you sure you want to delete this item?',
    'delete_success': 'Transaction deleted',
    'delete_failed': 'Unable to delete transaction',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'expense': 'Expense',
    'income': 'Income',
    'expense_short': 'Expense',
    'income_short': 'Income',
    'all': 'All',
    'no_note': 'No note',
    'no_activity': 'No activity yet',
  },
  'en': {
    'app_title': 'Expense Tracker',
    'app_tagline': 'Track money with clarity',
    'login': 'Login',
    'register_now': 'Register now',
    'forgot_password': 'Forgot password',
    'create_account': 'Create account',
    'send_request': 'Send request',
    'save_transaction': 'Save transaction',
    'delete_transaction': 'Delete transaction',
    'delete_confirm': 'Are you sure you want to delete this item?',
    'delete_success': 'Transaction deleted',
    'delete_failed': 'Unable to delete transaction',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'expense': 'Expense',
    'income': 'Income',
    'expense_short': 'Expense',
    'income_short': 'Income',
    'all': 'All',
    'no_note': 'No note',
    'no_activity': 'No activity yet',
  },
};
