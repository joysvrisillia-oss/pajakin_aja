import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/db_helper.dart';
import '../Models/pajak_model.dart';

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

  final Map<String, IconData> _pajakIcons = {
    'PPh Pribadi': Icons.person,
    'Pajak Bisnis (UMKM)': Icons.business_center,
    'Pajak Lainnya (PBB & PPN)': Icons.receipt_long,
  };

  final Map<String, Color> _pajakColors = {
    'PPh Pribadi': Colors.blue.shade700,
    'Pajak Bisnis (UMKM)': Colors.green.shade700,
    'Pajak Lainnya (PBB & PPN)': Colors.purple.shade700,
  };

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
      final hasil = _hitungPPhPribadiDetail(nilai);
      pajak = hasil['total'];
      List<String> lapisanList = hasil['rincian'];
      rincian = "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n\n"
          "PPh Pribadi (progresif UU HPP 2025)\n"
          "${lapisanList.join("\n")}\n"
          "Total = ${formatRupiah.format(pajak)}";
    } else if (_jenisPajak == 'Pajak Bisnis (UMKM)') {
      double tarif = 0.005;
      pajak = nilai * tarif;
      rincian = "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
          "Pajak UMKM (0.5%) = ${formatRupiah.format(pajak)}\n"
          "Total = ${formatRupiah.format(pajak)}";
    } else if (_jenisPajak == 'Pajak Lainnya (PBB & PPN)') {
      double pbb = nilai * 0.001;
      double ppn = nilai * 0.11;
      pajak = pbb + ppn;
      rincian = "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n\n"
          "PBB (0.1%) = ${formatRupiah.format(pbb)}\n"
          "PPN (11%) = ${formatRupiah.format(ppn)}\n"
          "PBB (0.1%) + PPN (11%) = ${formatRupiah.format(pajak)}\n"
          "Total = ${formatRupiah.format(pajak)}";
    }

    setState(() {
      _hasilPajak = pajak;
      _hasilRincian = rincian;
    });

    // Simpan ke SQLite
    await DBHelper.insertPajak(PajakModel(
      jenisPajak: _jenisPajak,
      nilai: nilai,
      pajak: pajak,
      waktu: DateTime.now().toString(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hasil pajak berhasil disimpan ke database SQLite.'),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Map<String, dynamic> _hitungPPhPribadiDetail(double penghasilan) {
    List<int> batas = [60000000, 250000000, 500000000, 5000000000];
    List<double> tarif = [0.05, 0.15, 0.25, 0.30, 0.35];

    double pajak = 0.0;
    List<String> rincianLapisan = [];

    for (int i = 0; i < tarif.length; i++) {
      double lower = (i == 0) ? 0.0 : batas[i - 1].toDouble();
      double upper = (i < batas.length) ? batas[i].toDouble() : double.infinity;

      if (penghasilan > lower) {
        double kena = (penghasilan < upper ? penghasilan : upper) - lower;
        double pajakLapisan = kena * tarif[i];
        pajak += pajakLapisan;
        rincianLapisan.add(
          "Lapisan ${i + 1} (${(tarif[i] * 100).toStringAsFixed(0)}%) = ${formatRupiah.format(pajakLapisan)}",
        );
      }
    }

    return {'total': pajak, 'rincian': rincianLapisan};
  }

  RichText _formatHasilText(String text) {
    List<TextSpan> spans = [];
    List<String> lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      if (line.contains('Total = Rp')) {
        spans.add(TextSpan(
          text: line,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ));
      } else {
        spans.add(TextSpan(
          text: line,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ));
      }
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return RichText(
      text: TextSpan(style: const TextStyle(height: 1.5), children: spans),
    );
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
                value: _jenisPajak,
                items: _pajakIcons.keys.map((jenis) {
                  return DropdownMenuItem(
                    value: jenis,
                    child: Row(
                      children: [
                        Icon(_pajakIcons[jenis], color: _pajakColors[jenis]),
                        const SizedBox(width: 8),
                        Text(jenis),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _jenisPajak = val!),
                decoration: const InputDecoration(
                  labelText: "Pilih Jenis Pajak",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calculate),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nilaiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                  "Masukkan Nilai (Penghasilan / Omzet / Nilai Objek)",
                  border: const OutlineInputBorder(),
                  prefixIcon: Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      "Rp",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _hitungPajak,
                  icon: Icon(_pajakIcons[_jenisPajak]),
                  label: const Text("Hitung & Simpan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_pajakIcons[_jenisPajak], color: _pajakColors[_jenisPajak]),
                          const SizedBox(width: 8),
                          Text(
                            "Hasil Perhitungan ${_jenisPajak.split(' ')[0]}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _formatHasilText(_hasilRincian),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
