import 'package:anonymous/src/screen/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anonymous/src/screen/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstLaunch = prefs.getBool('firstLaunch') ?? true;

  runApp(MyApp(firstLaunch: firstLaunch));
}

class MyApp extends StatelessWidget {
  final bool firstLaunch;

  MyApp({required this.firstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anonymous',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: firstLaunch ? WelcomeScreen() : LoginScreen(),
    );
  }
}
