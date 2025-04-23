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
    // Simulate splash screen delay
    Future.delayed(Duration(seconds: 2), () {
      print(
        'token di splash screen: ${PreferenceHandler.getToken().toString()}',
      );
      if (PreferenceHandler.getToken() != 'token') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/app_logo.png'),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     // Logo - Calendar icon with checkmark
        //     Icon(Icons.event_available, size: 64, color: Color(0xFF0D3B66)),
        //     SizedBox(height: 16),
        //     Text(
        //       'Zentri',
        //       style: TextStyle(
        //         fontSize: 28,
        //         fontWeight: FontWeight.bold,
        //         color: Color(0xFF0D3B66),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
