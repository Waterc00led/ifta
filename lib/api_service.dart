import 'package:http/http.dart' as http;
import 'package:ifta/components/jurisdiction_class.dart';
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

    var url = Uri.parse('$BASE_API_URL/eld/user');
    print(url);
    var response = await http.get(url, headers: headers.cast<String, String>());
    print(response);
    if (response.statusCode == 200) {
      print(response);
      return response.body;
    } else {
      print(response);
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> logout() async {
    var headers = {};

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

  static Future<void> postJurisdiction(List<JurisdictionClass> jurisdictionValues, String selectedQuarterYear) async {
    // Convert the list of JurisdictionClass objects into a list of maps
    List<Map<String, dynamic>> jurisdictionValuesJson = jurisdictionValues.map((item) => item.toJson()).toList();

    // Create the object
    Map<String, dynamic> data = {
      'jurisdictionValues': jurisdictionValuesJson,
      'selectedQuarterYear': selectedQuarterYear,
    };

    // Convert the object to JSON
    String body = jsonEncode(data);

    print(body);

    // // Send the POST request
    // http.Response response = await http.post(
    //   Uri.parse('https://your-api-endpoint.com'), // Replace with your API endpoint
    //   headers: {"Content-Type": "application/json"},
    //   body: body,
    // );

    // // Handle the response
    // if (response.statusCode == 200) {
    //   print('Success!');
    // } else {
    //   print('Failed to post jurisdiction. Status code: ${response.statusCode}');
    // }
  }
}
