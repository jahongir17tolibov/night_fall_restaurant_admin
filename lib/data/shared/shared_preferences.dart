// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static const String THEME_KEY = 'is_dark';
  static const String TABLE_NUMBER_KEY = 'table_number';
  static final Future<SharedPreferences> getInstance =
      SharedPreferences.getInstance();

  Future<bool> getAppTheme() async {
    final prefs = await getInstance;
    return prefs.getBool(THEME_KEY) ?? false;
  }

  Future<bool> setAppTheme(bool isDark) async {
    final prefs = await getInstance;
    return prefs.setBool(THEME_KEY, !isDark);
  }
}
