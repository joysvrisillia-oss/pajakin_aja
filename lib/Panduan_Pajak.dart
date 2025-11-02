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
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'PANDUAN & TIPS PAJAK',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Untuk memahami dan mengelola pajak dengan baik, berikut adalah beberapa panduan dan tips yang dapat membantu:\n',
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),

          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: '1. Pelajari Peraturan Terbaru\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Carilah informasi mengenai peraturan pajak terbaru yang dikeluarkan oleh otoritas pajak yang berwenang. Pastikan Anda memahami setiap peraturan dan bagaimana itu dapat mempengaruhi bisnis atau keuangan pribadi Anda.\n\n',
                ),
              ],
            ),
          ),

          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: '2. Konsultasikan dengan Ahli Pajak\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Mendapatkan saran dan panduan dari ahli pajak yang berpengalaman dapat membantu Anda memahami implikasi peraturan pajak terbaru dan memberikan strategi untuk memastikan kepatuhan.\n\n',
                ),
              ],
            ),
          ),

          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: '3. Perbarui Sistem Pencatatan Keuangan\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Pastikan sistem pencatatan keuangan Anda teratur dan terupdate. Dengan mengelola catatan keuangan dengan baik, Anda dapat dengan mudah melacak transaksi dan memastikan kepatuhan terhadap peraturan pajak terbaru.\n\n',
                ),
              ],
            ),
          ),

          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: '4. Perhitungkan Pajak Secara Akurat\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Pastikan Anda menghitung jumlah pajak dengan akurat untuk menghindari kesalahan dan sanksi.\n\n',
                ),
              ],
            ),
          ),

          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: '5. Simpan Bukti Transaksi Pajak\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Simpan setiap bukti pembayaran dan pelaporan pajak Anda sebagai arsip yang berguna bila diperlukan pemeriksaan pajak.\n\n',
                ),
              ],
            ),
          ),

          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                  text: '6. Manfaatkan Teknologi\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Gunakan aplikasi atau software pajak untuk mempermudah perhitungan dan pelaporan pajak secara efisien.\n\n'
                      'Dengan memahami hal-hal di atas, Anda dapat mengelola kewajiban pajak dengan lebih baik dan terhindar dari risiko denda atau sanksi.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(thickness: 1),
          const SizedBox(height: 10),

          const Text(
            'Penjelasan Singkat Kalkulator Pajak:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Kalkulator Pajak ini membantu menghitung estimasi pajak Anda secara otomatis '
                'berdasarkan jenis pajak yang dipilih. Berikut cara perhitungannya:\n',
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
              children: [
                TextSpan(
                  text: '• PPh Pribadi: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Menggunakan sistem progresif sesuai UU HPP 2025, di mana setiap lapisan penghasilan '
                      'memiliki tarif berbeda (5%, 15%, 25%, 30%, 35%). Semakin tinggi penghasilan, '
                      'semakin tinggi tarif pajaknya.\n\n',
                ),
                TextSpan(
                  text: '• Pajak UMKM: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'Dihitung sebesar 0.5% dari omzet per tahun, sesuai ketentuan pemerintah untuk pelaku usaha kecil dan menengah.\n\n',
                ),
                TextSpan(
                  text: '• PBB & PPN: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                  'PBB dikenakan 0.1% dan PPN sebesar 11% dari nilai objek pajak. Kalkulator menjumlahkan keduanya otomatis.\n\n',
                ),
                TextSpan(
                  text:
                  'Hasil “Total = ...” menunjukkan jumlah pajak akhir yang perlu dibayarkan. '
                      'Angka ini bersifat estimasi untuk mempermudah perencanaan pajak Anda.\n',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Dengan memahami cara kerja kalkulator ini, diharapkan Anda dapat menghitung estimasi pajak dengan mudah, cepat, dan lebih akurat untuk mendukung perencanaan keuangan yang lebih baik.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
