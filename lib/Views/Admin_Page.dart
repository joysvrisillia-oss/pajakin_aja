import 'package:flutter/material.dart';
import '../Database/db_helper.dart';
import '../Auth/login_page.dart';
import 'kalkulator_pajak.dart';
import 'Admin_Panduan_Page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await DBHelper.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          )
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text("Kelola Perhitungan Pajak"),
            subtitle: const Text("Admin dapat mengedit, menghapus atau review data pajak"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KalkulatorPajak()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("Kelola Panduan Pajak"),
            subtitle: const Text("Admin bisa update panduan"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanduanPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
