<<<<<<< HEAD
=======

>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
import 'package:flutter/material.dart';
import 'Kalkulator_Pajak.dart';
import 'Riwayat_Perhitungan.dart';
import 'Panduan_Pajak.dart';
import 'Material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryBlue, lightBlue],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
<<<<<<< HEAD

            const SizedBox(height: 20),
            Image.asset(
              'assets/logo.png',
=======
            const Text(
              'Pajakin Aja!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/logo.png',
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang di Pajakin Aja!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
<<<<<<< HEAD
              'Hitung pajak pribadi, bisnis, dan lainnya dengan cepat\n& akurat.',
=======
              'Hitung pajak pribadi, bisnis, dan lainnya dengan cepat\n& akurat',
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF5FF),
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    MenuCard(
                      icon: Icons.calculate_outlined,
                      title: 'Kalkulator Pajak',
                      subtitle: 'PPh, UMKM, PBB & PPN',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KalkulatorPajak(),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      icon: Icons.history,
                      title: 'Riwayat Perhitungan',
                      subtitle: 'Daftar perhitungan tersimpan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const RiwayatPerhitunganPage(),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      icon: Icons.info_outline,
                      title: 'Panduan & Tips Pajak',
                      subtitle: 'Aturan dan tips singkat',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PanduanPajakPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: primaryBlue),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, color: primaryBlue),
        onTap: onTap,
      ),
    );
  }
}
