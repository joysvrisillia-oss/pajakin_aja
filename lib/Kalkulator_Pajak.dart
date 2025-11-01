
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class KalkulatorPajak extends StatefulWidget {
  const KalkulatorPajak({super.key});

  @override
  State<KalkulatorPajak> createState() => _KalkulatorPajakState();
}

class _KalkulatorPajakState extends State<KalkulatorPajak> {
  final TextEditingController _nilaiController = TextEditingController();
  String _jenisPajak = 'PPh Pribadi';
  String _hasilRincian = "";
  double _hasilPajak = 0.0;

  final formatRupiah =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _hitungPajak() async {
    double nilai = double.tryParse(_nilaiController.text) ?? 0.0;

    if (nilai <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nilai yang valid!')),
      );
      return;
    }

    double pajak = 0.0;
    String rincian = "";

    if (_jenisPajak == 'PPh Pribadi') {
      pajak = _hitungPPhPribadi(nilai);
      rincian =
      "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
          "PPh Pribadi (progresif UU HPP 2025)\n"
          "Total = ${formatRupiah.format(pajak)}";
    } else if (_jenisPajak == 'Pajak Bisnis (UMKM)') {
      double tarif = 0.005;
      pajak = nilai * tarif;
      rincian =
      "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
          "Pajak UMKM (0.5%) = ${formatRupiah.format(pajak)}\n"
          "Total = ${formatRupiah.format(pajak)}";
    } else if (_jenisPajak == 'Pajak Lainnya (PBB & PPN)') {
      double pbb = nilai * 0.001; // 0.1%
      double ppn = nilai * 0.11;  // 11%
      pajak = pbb + ppn;
      rincian =
      "PBB (0.1%) + PPN (11%) = ${formatRupiah.format(pajak)}\n\n"
          "Rincian Perhitungan :\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
          "PBB (0.1%) = ${formatRupiah.format(pbb)}\n"
          "PPN (11%) = ${formatRupiah.format(ppn)}\n"
          "Total = ${formatRupiah.format(pajak)}";
    }

    setState(() {
      _hasilPajak = pajak;
      _hasilRincian = rincian;
    });

    // Simpan ke riwayat
    final prefs = await SharedPreferences.getInstance();
    List<String> riwayat = prefs.getStringList('riwayat') ?? [];
    riwayat.add(
        '$_jenisPajak - Nilai: ${formatRupiah.format(nilai)} | Pajak: ${formatRupiah.format(pajak)}');
    await prefs.setStringList('riwayat', riwayat);

    // Notifikasi kecil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hasil pajak berhasil disimpan ke riwayat.'),
        duration: Duration(seconds: 5),
      ),
    );
  }

  double _hitungPPhPribadi(double penghasilan) {
    // Tarif progresif sesuai UU HPP 2025
    List<int> batas = [60000000, 250000000, 500000000, 5000000000];
    List<double> tarif = [0.05, 0.15, 0.25, 0.30, 0.35];

    double sisa = penghasilan;
    double pajak = 0.0;

    for (int i = 0; i < tarif.length && sisa > 0; i++) {
      double bagian = (i < batas.length) ? batas[i].toDouble() : sisa;
      double kena = sisa >= bagian ? bagian : sisa;
      pajak += kena * tarif[i];
      sisa -= kena;
    }
    return pajak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalkulator Pajak"),
        backgroundColor: Colors.blue.shade800,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _jenisPajak,
                items: const [
                  DropdownMenuItem(value: 'PPh Pribadi', child: Text('PPh Pribadi')),
                  DropdownMenuItem(value: 'Pajak Bisnis (UMKM)', child: Text('Pajak Bisnis (UMKM)')),
                  DropdownMenuItem(value: 'Pajak Lainnya (PBB & PPN)', child: Text('Pajak Lainnya (PBB & PPN)')),
                ],
                onChanged: (val) => setState(() => _jenisPajak = val!),
                decoration: const InputDecoration(
                  labelText: "Pilih Jenis Pajak",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nilaiController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Masukkan Nilai (Penghasilan / Omzet / Nilai Objek)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _hitungPajak,
                  icon: const Icon(Icons.calculate),
                  label: const Text("Hitung & Simpan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_hasilRincian.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _hasilRincian,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
