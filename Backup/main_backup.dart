import 'package:flutter/material.dart';
import 'Views_backup/Home_Page_backup.dart';
import 'Views_backup/Kalkulator_Pajak_backup.dart';
import 'Views_backup/Riwayat_Perhitungan_backup.dart';
import 'Utils_backup/material_backup.dart';

void main() {
  runApp(const PajakinApp());
}

class PajakinApp extends StatelessWidget {
  const PajakinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pajakin Aja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}