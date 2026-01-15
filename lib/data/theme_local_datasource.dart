import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalDatasource {
  static const _keyTheme = 'is_dark_mode';

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTheme) ?? false;
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTheme, isDark);
  }
}
