import 'package:flutter/material.dart';
import 'package:ifta/api_service.dart';
import 'package:ifta/home_page.dart';
import 'package:ifta/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeIn,
    );

    initUser();
  }

  Future<void> initUser() async {
    print("initUser");
    try {
      String response = await ApiService.getUser();
      await ApiService.getTemplates();
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
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Transform.scale(
            scale: _animation.value,
            child: child,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}