import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'api_service.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// Create login page

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;

  Future<void> performLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Loading..."),
                ),
              ],
            ),
          );
        },
      );

      bool success = await ApiService.login(_username, _password);

      // Dismiss loading dialog
      Navigator.of(context).pop();

      if (success) {
        print("done");
        // If server returns an OK response, navigate to HomePage.
        // navigate to home page
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Handle login failure
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              initialValue: "lvander@test.com",
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(value!)) {
                  return 'Enter Valid Email';
                } else {
                  return null;
                }
              },
              onSaved: (value) => _username = value.toString(),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              initialValue: "abc123pass",
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) => _password = value.toString(),
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: performLogin,
            ),
          ],
        ),
      ),
    );
  }
}
