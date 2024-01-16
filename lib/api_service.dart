import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:ifta/cookie_manager.dart';
import 'package:ifta/user_preferences.dart';
import 'dart:convert';

class ApiService {
  static const String BASE_API_URL = 'http://eldlab.synodicinc.com:8081/api';

  static Future<bool> login(String username, String password) async {
    var url = Uri.parse('$BASE_API_URL/session');
    var response =
        await http.post(url, body: {'email': username, 'password': password});
    if (response.statusCode == 200) {
      var headers = response.headers;
      var cookie = headers['set-cookie'];
      if (cookie != null) {
        await CookieManager.saveCookie(cookie);
      }

      // Parse the response body as JSON
      var data = jsonDecode(response.body);

      // Extract the user's name from the JSON data
      var name = data['name'];

      // Save the user's name
      await UserPreferences.saveUserName(name);

      return true;
    } else {
      return false;
    }
  }

  static Future<String> getTemplates() async {
  var headers = {};
  if (Platform.isAndroid || Platform.isIOS || Platform.isWindows) {
    var cookie = await CookieManager.getCookie();
    headers = {'cookie': cookie};
  }

  var url = Uri.parse('$BASE_API_URL/eld/system/document/template');
  var response = await http.get(url, headers: headers.cast<String, String>());
  if (response.statusCode == 200) {

    UserPreferences.saveIftaValues(response.body);

    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
}

  static Future<String> getUser() async {
    var headers = {};
    if (Platform.isAndroid || Platform.isIOS || Platform.isWindows) {
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
    if (Platform.isAndroid || Platform.isIOS || Platform.isWindows) {
      var cookie = await CookieManager.getCookie();
      headers = {'cookie': cookie};
      await CookieManager.saveCookie('');
    }

    await UserPreferences.deleteUser();

    var url = Uri.parse('$BASE_API_URL/session');
    var response =
        await http.delete(url, headers: headers.cast<String, String>());
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
