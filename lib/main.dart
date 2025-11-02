import 'package:flutter/material.dart';
import 'Home_Page.dart';
import 'Kalkulator_Pajak.dart';
import 'Riwayat_Perhitungan.dart';
import 'Material.dart';




import 'package:flutter/material.dart';
import 'Home_Page.dart';
import 'Material.dart';

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
