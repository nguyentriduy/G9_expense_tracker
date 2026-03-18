import 'package:flutter/widgets.dart';

@immutable
class AppPreferences {
  const AppPreferences({this.languageCode = 'vi', this.currencyCode = 'VND'});

  final String languageCode;
  final String currencyCode;
}

class AppPreferencesScope extends InheritedWidget {
  const AppPreferencesScope({
    super.key,
    required super.child,
    this.preferences = const AppPreferences(),
  });

  final AppPreferences preferences;

  static AppPreferences of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<AppPreferencesScope>()
            ?.preferences ??
        const AppPreferences();
  }

  @override
  bool updateShouldNotify(covariant AppPreferencesScope oldWidget) {
    return oldWidget.preferences != preferences;
  }
}
