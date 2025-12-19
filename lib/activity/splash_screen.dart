import 'package:cwi_app/activity/login.dart';
import 'package:cwi_app/activity/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Called when this object is inserted into the tree.
  ///
  /// This function is responsible for checking if the user is already logged in
  /// and navigating to the main page if so.
  /*******  9e70dcf7-a19f-4baa-825b-7896cfcef36a  *******/
  void initState() {
    super.initState();

    // Check if logged in
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int? userId = prefs.getInt('userId');

    Widget nextPage;
    if (token != null && userId != null) {
      nextPage = MainPage(userId: userId.toString());
    } else {
      nextPage = const Loginpage();
    }

    // Delay 2 detik kemudian pindah
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
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
