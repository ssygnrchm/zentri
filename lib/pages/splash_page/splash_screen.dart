import 'package:flutter/material.dart';
import 'package:zentri/services/shared_preferences/prefs_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      String token = await PrefsHandler.getToken();
      print("isi token: $token");
      if (token.isEmpty || token == "") {
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        Navigator.pushReplacementNamed(context, "/main");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/images/app_logo.png")),
    );
  }
}
