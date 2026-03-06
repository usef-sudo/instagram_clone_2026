import 'package:flutter/material.dart';
import 'package:instagram_clone/presentation/pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({ super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      navigateToLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.network(
              "https://unblast.com/wp-content/uploads/2025/07/instagram-logo-colored.jpg")),
    );
  }

  Future<void> navigateToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userUid = prefs.getString("userUid") ?? "";

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => userUid == ""
              ? LoginScreen(

                )
              : HomeScreen(userUid)),
    );
  }
}
