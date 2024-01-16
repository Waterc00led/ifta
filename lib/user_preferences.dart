import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', userName);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }

  // save ifta values response
  static Future<void> saveIftaValues(String iftaValues) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('iftaValues', iftaValues);
  }

  // get ifta values response
  static Future<String?> getIftaValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('iftaValues');
  }
}