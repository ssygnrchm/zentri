import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zentri/pages/auth_pages/login/login_page.dart';
import 'package:zentri/pages/auth_pages/register/register_page.dart';
import 'package:zentri/pages/splash_page/splash_screen.dart';
import 'package:zentri/pages/user_pages/main_screen/main_screen.dart';
import 'package:zentri/services/providers/attendance_provider.dart';
import 'package:zentri/services/providers/auth_provider.dart';
import 'package:zentri/services/providers/maps_provider.dart';
import 'package:zentri/services/providers/profile_provider.dart';
import 'package:zentri/services/providers/widget_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WidgetProvider()),
        ChangeNotifierProvider(create: (context) => MapsProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/main": (context) => MainScreen(),
      },
    );
  }
}
