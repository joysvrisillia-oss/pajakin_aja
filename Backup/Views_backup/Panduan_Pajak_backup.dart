import 'package:flutter/material.dart';

class PanduanPajakPage extends StatelessWidget {
  const PanduanPajakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Panduan & Tips Pajak'),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'PANDUAN & TIPS PAJAK',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Untuk memahami dan mengelola pajak dengan baik, berikut beberapa panduan dan tips penting yang dapat membantu:\n',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10),

          // Nomor 1
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '1. Pelajari Peraturan Terbaru\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Selalu perbarui informasi Anda mengenai kebijakan pajak terkini dari pemerintah. Ini membantu Anda tetap patuh dan menghindari kesalahan administratif.\n\n'),
              ],
            ),
            textAlign: TextAlign.justify,
          ),

          // Nomor 2
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '2. Konsultasikan dengan Ahli Pajak\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Jika bingung, mintalah saran kepada konsultan pajak. Mereka dapat membantu merencanakan strategi pembayaran pajak yang efisien.\n\n'),
              ],
            ),
            textAlign: TextAlign.justify,
          ),

          // Nomor 3
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '3. Catat Semua Transaksi\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Pastikan pembukuan keuangan Anda lengkap dan akurat. Catatan yang baik memudahkan pelaporan dan audit pajak.\n\n'),
              ],
            ),
            textAlign: TextAlign.justify,
          ),

          // Nomor 4
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '4. Gunakan Kalkulator Pajak\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Aplikasi Pajakin Aja membantu Anda menghitung pajak secara otomatis sesuai jenis pajaknya — PPh, UMKM, PBB, maupun PPN.\n\n'),
              ],
            ),
            textAlign: TextAlign.justify,
          ),

          // Nomor 5
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '5. Simpan Bukti Transaksi Pajak\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Simpan setiap bukti pembayaran dan pelaporan pajak Anda sebagai arsip penting bila dilakukan pemeriksaan pajak.\n\n'),
              ],
            ),
            textAlign: TextAlign.justify,
          ),

          // Nomor 6
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '6. Manfaatkan Teknologi\n',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Gunakan aplikasi atau software pajak agar proses hitung dan pelaporan menjadi efisien, cepat, dan akurat.\n\n'),
              ],
            ),
            textAlign: TextAlign.justify,
          ),

          Divider(thickness: 1),
          SizedBox(height: 10),

          Text(
            'Penjelasan Kalkulator Pajak:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kalkulator ini menghitung estimasi pajak otomatis sesuai kategori:',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
              children: [
                TextSpan(
                    text: '• PPh Pribadi: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Menggunakan tarif progresif (5–35%) sesuai UU HPP 2025.\n\n'),
                TextSpan(
                    text: '• Pajak UMKM: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'Dihitung 0.5% dari omzet tahunan bagi pelaku usaha kecil.\n\n'),
                TextSpan(
                    text: '• PBB & PPN: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                    'PBB sebesar 0.1% dan PPN 11% dari nilai objek pajak.\n'),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 12),
          Text(
            'Angka hasil perhitungan bersifat estimasi untuk membantu perencanaan keuangan dan kepatuhan pajak.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
