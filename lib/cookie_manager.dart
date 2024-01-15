import 'package:shared_preferences/shared_preferences.dart';

class CookieManager {
  static Future<void> saveCookie(String cookie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cookie', cookie);
  }

  static Future<String?> getCookie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookie');
  }
}
