import 'package:flutter/material.dart';
import 'package:ifta/api_service.dart';
import 'package:ifta/cookie_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:ifta/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var headers = {};
    if (Platform.isAndroid) {
      var cookie = await CookieManager.getCookie();
      headers = {'cookie': cookie};
    }

    var url = Uri.parse('http://eldlab.synodicinc.com:8081/api/eld/user');
    var cookie = await CookieManager.getCookie();
    var response = await http.get(url, headers: headers.cast<String, String>());
    if (response.statusCode == 200) {
      print("done2");
      print('Data: ${response.body}');
    } else {
      print("not done2");
      //throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IFTA Calculator'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                bool success = await ApiService.logout();
                if (success) {
                  print('Logout successful');
                  // Then close the drawer and navigate to the login page
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  print('Logout failed');
                }
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to IFTA Calculator',
            ),
          ],
        ),
      ),
    );
  }
}
