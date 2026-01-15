import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  static const _keyLogin = 'is_logged_in';

  Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLogin, true);
  }

  Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogin);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLogin) ?? false;
  }
}
