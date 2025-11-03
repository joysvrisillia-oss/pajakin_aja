import 'package:flutter/material.dart';
import 'Views/Home_Page.dart';
import 'Views/Kalkulator_Pajak.dart';
import 'Views/Riwayat_Perhitungan.dart';
import 'Utils/Material.dart';




import 'package:flutter/material.dart';
import 'Views/Home_Page.dart';
import 'Utils/Material.dart';

void main() {
  runApp(const PajakinApp());
}

class PajakinApp extends StatelessWidget {
  const PajakinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pajakin Aja!',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
