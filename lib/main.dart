import 'package:flutter/material.dart';
import 'package:zentri/auth/login_screen.dart';
import 'package:zentri/auth/register_screen.dart';
import 'package:zentri/presentation/history_screen.dart';
import 'package:zentri/presentation/home_screen.dart';
import 'package:zentri/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zentri App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/history': (context) => AttendanceHistoryScreen(),
      },
    );
  }
}
