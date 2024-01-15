import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:ifta/cookie_manager.dart';

class ApiService {
  static const String BASE_API_URL = 'http://eldlab.synodicinc.com:8081/api';

  static Future<bool> login(String username, String password) async {
    var url = Uri.parse('$BASE_API_URL/session');
    var response =
        await http.post(url, body: {'email': username, 'password': password});
    if (response.statusCode == 200) {

      // Save cookie
      var headers = response.headers;
      var cookie = headers['set-cookie'];
      if (cookie != null) {
        await CookieManager.saveCookie(cookie);
      }
      
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getUser() async {
    var headers = {};
    if (Platform.isAndroid) {
      var cookie = await CookieManager.getCookie();
      headers = {'cookie': cookie};
    }

    var url = Uri.parse('$BASE_API_URL/eld/user');
    var response = await http.get(url, headers: headers.cast<String, String>());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> logout() async {
  var headers = {};
  if (Platform.isAndroid) {
    var cookie = await CookieManager.getCookie();
    headers = {'cookie': cookie};
    await CookieManager.saveCookie('');
  }

  var url = Uri.parse('$BASE_API_URL/session');
  var response = await http.delete(url, headers: headers.cast<String, String>());
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    // Handle the case where the user is already logged out
    print('User is already logged out');
    return false;
  } else {
    return false;
  }
}
}
