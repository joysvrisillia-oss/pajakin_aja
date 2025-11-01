
import 'package:flutter/material.dart';

class PanduanPajakPage extends StatelessWidget {
  const PanduanPajakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan & Tips Pajak'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'PANDUAN & TIPS PAJAK',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Untuk memahami dan mengelola pajak dengan baik, berikut adalah beberapa panduan dan tips yang dapat membantu:\n',
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),

          // Nomor 1
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

          // Nomor 2
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

          // Nomor 3
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

          // Nomor 4
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

          // Nomor 5
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

          // Nomor 6
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
        ],
      ),
    );
  }
}
