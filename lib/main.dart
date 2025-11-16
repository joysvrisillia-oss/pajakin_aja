import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/Home_Page.dart';
import 'Auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(PajakinApp(isLoggedIn: isLoggedIn));
}

class PajakinApp extends StatelessWidget {
  final bool isLoggedIn;
  const PajakinApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pajakin Aja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
