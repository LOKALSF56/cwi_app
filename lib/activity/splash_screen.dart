import 'package:cwi_app/activity/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 2 detik kemudian pindah ke MainPage
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF008080);
    const String logoImagePath = 'assets/logo.png';

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(logoImagePath, width: 200, height: 200),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
