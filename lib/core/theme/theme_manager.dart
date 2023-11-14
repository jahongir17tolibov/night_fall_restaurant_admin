import 'package:flutter/material.dart';
import 'package:night_fall_restaurant_admin/data/shared/shared_preferences.dart';

class ThemeManger with ChangeNotifier {
  final AppSharedPreferences sharedPrefs;

  ThemeManger(this.sharedPrefs, this._themeMode);

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await sharedPrefs.setAppTheme(isDark);
    notifyListeners();
  }

  Future<ThemeMode> getThemeMode() async {
    bool theme = await sharedPrefs.getAppTheme();
    return theme ? ThemeMode.light : ThemeMode.dark;
  }
}
