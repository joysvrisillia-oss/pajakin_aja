<<<<<<< HEAD
=======

>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
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

<<<<<<< HEAD
  final Map<String, IconData> _pajakIcons = {
    'PPh Pribadi': Icons.person,
    'Pajak Bisnis (UMKM)': Icons.business_center,
    'Pajak Lainnya (PBB & PPN)': Icons.receipt_long,
  };

=======
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
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
<<<<<<< HEAD
    String rincianLapisan = "";

    if (_jenisPajak == 'PPh Pribadi') {
      final hasil = _hitungPPhPribadiDetail(nilai);
      pajak = hasil['total'];
      List<String> lapisanList = hasil['rincian'];
      rincianLapisan = lapisanList.join('|');

      if (lapisanList.length > 1) {
        rincian = "Rincian Perhitungan:\n"
            "Dasar Nilai : ${formatRupiah.format(nilai)}\n\n"
            "PPh Pribadi (progresif UU HPP 2025)\n"
            "${lapisanList.join("\n")}\n"
            "Total = ${formatRupiah.format(pajak)}";
      } else {
        rincian = "Rincian Perhitungan:\n"
            "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
            "PPh Pribadi (progresif UU HPP 2025)\n"
            "Total = ${formatRupiah.format(pajak)}";
      }
    } else if (_jenisPajak == 'Pajak Bisnis (UMKM)') {
      double tarif = 0.005;
      pajak = nilai * tarif;
      rincian = "Rincian Perhitungan:\n"
=======

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
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
          "Pajak UMKM (0.5%) = ${formatRupiah.format(pajak)}\n"
          "Total = ${formatRupiah.format(pajak)}";
    } else if (_jenisPajak == 'Pajak Lainnya (PBB & PPN)') {
<<<<<<< HEAD
      double pbb = nilai * 0.001;
      double ppn = nilai * 0.11;
      pajak = pbb + ppn;
      rincian = "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n\n"
          "PBB (0.1%) = ${formatRupiah.format(pbb)}\n"
          "PPN (11%) = ${formatRupiah.format(ppn)}\n"
          "PBB (0.1%) + PPN (11%) = ${formatRupiah.format(pajak)}\n"
=======
      double pbb = nilai * 0.001; // 0.1%
      double ppn = nilai * 0.11;  // 11%
      pajak = pbb + ppn;
      rincian =
      "PBB (0.1%) + PPN (11%) = ${formatRupiah.format(pajak)}\n\n"
          "Rincian Perhitungan :\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
          "PBB (0.1%) = ${formatRupiah.format(pbb)}\n"
          "PPN (11%) = ${formatRupiah.format(ppn)}\n"
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
          "Total = ${formatRupiah.format(pajak)}";
    }

    setState(() {
      _hasilPajak = pajak;
      _hasilRincian = rincian;
    });

<<<<<<< HEAD
    final prefs = await SharedPreferences.getInstance();
    List<String> riwayat = prefs.getStringList('riwayat') ?? [];

    // GANTI bagian penyimpanan riwayat:
    String dataRiwayat = '$_jenisPajak|${formatRupiah.format(nilai)}|${formatRupiah.format(pajak)}|$rincianLapisan';
    riwayat.add(dataRiwayat);

    await prefs.setStringList('riwayat', riwayat);

=======
    // Simpan ke riwayat
    final prefs = await SharedPreferences.getInstance();
    List<String> riwayat = prefs.getStringList('riwayat') ?? [];
    riwayat.add(
        '$_jenisPajak - Nilai: ${formatRupiah.format(nilai)} | Pajak: ${formatRupiah.format(pajak)}');
    await prefs.setStringList('riwayat', riwayat);

    // Notifikasi kecil
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hasil pajak berhasil disimpan ke riwayat.'),
        duration: Duration(seconds: 5),
      ),
    );
  }

<<<<<<< HEAD
  Map<String, dynamic> _hitungPPhPribadiDetail(double penghasilan) {
    List<int> batas = [60000000, 250000000, 500000000, 5000000000];
    List<double> tarif = [0.05, 0.15, 0.25, 0.30, 0.35];

    double pajak = 0.0;
    List<String> rincianLapisan = [];

    for (int i = 0; i < tarif.length; i++) {
      double lower = (i == 0) ? 0.0 : batas[i - 1].toDouble();
      double upper = (i < batas.length) ? batas[i].toDouble() : double.infinity;

      double kena = 0.0;
      if (penghasilan > lower) {
        double sampai = penghasilan < upper ? penghasilan : upper;
        kena = sampai - lower;
        if (kena < 0) kena = 0.0;
      }

      if (kena <= 0) continue;

      double pajakLapisan = kena * tarif[i];
      pajak += pajakLapisan;

      String nilaiText = formatRupiah.format(pajakLapisan);
      rincianLapisan.add("Lapisan ${i + 1} (${(tarif[i] * 100).toStringAsFixed(0)}%) = $nilaiText");
    }

    if (rincianLapisan.length == 1) {
      String only = rincianLapisan.first;
      String revised = only.replaceFirstMapped(RegExp(r'Lapisan\s+(\d+)\s+\([0-9]+%\)\s*=\s*'), (m) {
        return 'Lapisan ${m[1]} = ';
      });
      if (revised == only) {
        int eq = only.indexOf('=');
        if (eq != -1) {
          String after = only.substring(eq + 1).trim();
          revised = 'Lapisan 1 = $after';
        }
      }
      rincianLapisan[0] = revised;
    }

    return {
      'total': pajak,
      'rincian': rincianLapisan,
    };
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: line,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ));
      }
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return RichText(
      text: TextSpan(style: const TextStyle(height: 1.5), children: spans),
    );
=======
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
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
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
<<<<<<< HEAD
                value: _jenisPajak,
                items: [
                  DropdownMenuItem(
                    value: 'PPh Pribadi',
                    child: Row(
                      children: [
                        Icon(_pajakIcons['PPh Pribadi'],
                            color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        const Text('PPh Pribadi'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Pajak Bisnis (UMKM)',
                    child: Row(
                      children: [
                        Icon(_pajakIcons['Pajak Bisnis (UMKM)'],
                            color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        const Text('Pajak Bisnis (UMKM)'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Pajak Lainnya (PBB & PPN)',
                    child: Row(
                      children: [
                        Icon(_pajakIcons['Pajak Lainnya (PBB & PPN)'],
                            color: Colors.purple.shade700),
                        const SizedBox(width: 8),
                        const Text('Pajak Lainnya (PBB & PPN)'),
                      ],
                    ),
                  ),
=======
                initialValue: _jenisPajak,
                items: const [
                  DropdownMenuItem(value: 'PPh Pribadi', child: Text('PPh Pribadi')),
                  DropdownMenuItem(value: 'Pajak Bisnis (UMKM)', child: Text('Pajak Bisnis (UMKM)')),
                  DropdownMenuItem(value: 'Pajak Lainnya (PBB & PPN)', child: Text('Pajak Lainnya (PBB & PPN)')),
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
                ],
                onChanged: (val) => setState(() => _jenisPajak = val!),
                decoration: const InputDecoration(
                  labelText: "Pilih Jenis Pajak",
                  border: OutlineInputBorder(),
<<<<<<< HEAD
                  prefixIcon: Icon(Icons.calculate),
=======
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nilaiController,
                keyboardType: TextInputType.number,
<<<<<<< HEAD
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
=======
                decoration: const InputDecoration(
                  labelText: "Masukkan Nilai (Penghasilan / Omzet / Nilai Objek)",
                  border: OutlineInputBorder(),
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _hitungPajak,
<<<<<<< HEAD
                  icon: Icon(_pajakIcons[_jenisPajak]),
=======
                  icon: const Icon(Icons.calculate),
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
                  label: const Text("Hitung & Simpan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
<<<<<<< HEAD
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
=======
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
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
<<<<<<< HEAD
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_pajakIcons[_jenisPajak],
                              color: Colors.blue.shade700),
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
=======
                  ),
                  child: Text(
                    _hasilRincian,
                    style: const TextStyle(fontSize: 16, height: 1.5),
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 6c1cc143556c4c7dadd7d75c38a5dbdaf6d09701
