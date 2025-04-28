import 'package:flutter/material.dart';
import 'package:zentri/services/pref_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // Simulate splash screen delay
    await Future.delayed(Duration(seconds: 2));

    // Get preference handler instance
    final prefHandler = await PreferenceHandler.getInstance();

    // Get the token
    final token = prefHandler.getToken();

    // Debug print
    print('Token in splash screen: $token');

    // Navigate based on token existence
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/images/app_logo.png')),
    );
  }
}
