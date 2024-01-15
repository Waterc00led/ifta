import 'package:flutter/material.dart';
import 'package:ifta/api_service.dart';
import 'package:ifta/home_page.dart';
import 'package:ifta/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
    try {
      String response = await ApiService.getUser();
      // If getUser is successful, navigate to HomePage
      print("ok");
      print(response);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print("not ok");
      // If getUser throws an exception, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
