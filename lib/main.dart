import 'package:flutter/material.dart';
import 'Views/Home_Page.dart';
import 'Auth/login_page.dart';
import 'Database/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final email = await DBHelper.getLoggedInUser();

  runApp(PajakinApp(
    isLoggedIn: email != null,
  ));
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
