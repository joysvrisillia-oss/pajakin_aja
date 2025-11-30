import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/db_helper.dart';
import '../Models/pajak_model.dart';
import 'Admin_Edit_Regulasi_Page.dart';

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

  bool _isAdmin = false;
  Map<String, dynamic> _taxSettings = {};

  final formatRupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final Map<String, IconData> _pajakIcons = {
    'PPh Pribadi': Icons.person,
    'Pajak Bisnis (UMKM)': Icons.business_center,
    'Pajak Lainnya (PBB & PPN)': Icons.receipt_long,
  };

  final Map<String, Color> _pajakColors = {
    'PPh Pribadi': Colors.blue,
    'Pajak Bisnis (UMKM)': Colors.green,
    'Pajak Lainnya (PBB & PPN)': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _cekRole();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final s = await DBHelper.getTaxSettings();
    setState(() {
      _taxSettings = s;
    });
  }

  Future<void> _cekRole() async {
    try {
      final role = await DBHelper.getLoggedInUserRole();
      setState(() {
        _isAdmin = (role != null && role.toLowerCase() == 'admin');
      });
    } catch (_) {
      final email = await DBHelper.getLoggedInUser();
      setState(() {
        _isAdmin = (email != null && email == 'admin@example.com');
      });
    }
  }

  String _fmtPercent(double value) {
    double perc = value * 100;
    double frac = (perc - perc.truncate()).abs();
    if (frac < 1e-9) {
      return "${perc.toInt()}%";
    }
    String s = perc.toStringAsFixed(2);
    s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return "$s%";
  }

  String _fmtPercentPlain(double value) {
    double perc = value * 100;
    double frac = (perc - perc.truncate()).abs();
    if (frac < 1e-9) {
      return perc.toInt().toString();
    }
    String s = perc.toStringAsFixed(2);
    s = s.replaceFirst(RegExp(r'\.?0+$'), '');
    return s;
  }

  void _hitungPajak() async {
    double nilai = double.tryParse(_nilaiController.text) ?? 0.0;

    if (nilai <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nilai yang valid!')));
      return;
    }

    double pajak = 0.0;
    String rincian = "";

    // Pastikan pengaturan pajak sudah dimuat
    if (_taxSettings.isEmpty) {
      await _loadSettings();
    }

    if (_jenisPajak == 'PPh Pribadi') {
      final hasil = _hitungPPhPribadiDetail(nilai);
      pajak = hasil['total'];
      List<String> lapisanList = hasil['rincian'];
      rincian =
      "Rincian Perhitungan:\nDasar Nilai : ${formatRupiah.format(nilai)}\n\nPPh Pribadi (progresif)\n${lapisanList.join("\n")}\nTotal = ${formatRupiah.format(pajak)}";
    } else if (_jenisPajak == 'Pajak Bisnis (UMKM)') {
      final umkmRate = (_taxSettings['umkm'] ?? 0.005) as double;
      pajak = nilai * umkmRate;
      rincian =
      "Rincian Perhitungan:\nDasar Nilai : ${formatRupiah.format(nilai)}\nPajak UMKM (${_fmtPercent(umkmRate)}) = ${formatRupiah.format(pajak)}\nTotal = ${formatRupiah.format(pajak)}";
    } else if (_jenisPajak == 'Pajak Lainnya (PBB & PPN)') {
      final pbbRate = (_taxSettings['pbb'] ?? 0.001) as double;
      final ppnRate = (_taxSettings['ppn'] ?? 0.11) as double;
      double pbb = nilai * pbbRate;
      double ppn = nilai * ppnRate;
      pajak = pbb + ppn;
      rincian =
      "Rincian Perhitungan:\nDasar Nilai : ${formatRupiah.format(nilai)}\n\nPBB (${_fmtPercent(pbbRate)}) = ${formatRupiah.format(pbb)}\nPPN (${_fmtPercent(ppnRate)}) = ${formatRupiah.format(ppn)}\nTotal = ${formatRupiah.format(pajak)}";
    }

    setState(() {
      _hasilPajak = pajak;
      _hasilRincian = rincian;
    });

    final email = await DBHelper.getLoggedInUser();

    // 1. Buat objek PajakModel
    final newPajak = PajakModel(
        jenisPajak: _jenisPajak,
        nilai: nilai,
        pajak: pajak,
        waktu: DateTime.now().toString(),
        userEmail: email ?? ''
    );

    // 2. PERBAIKAN: Gunakan .toMap() saat memanggil DBHelper.insertPajak
    await DBHelper.insertPajak(newPajak.toMap());

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hasil pajak berhasil disimpan ke database SQLite.'), duration: Duration(seconds: 3)));
  }

  Map<String, dynamic> _hitungPPhPribadiDetail(double penghasilan) {
    final List<dynamic>? pphList = _taxSettings['pph'] as List<dynamic>?;

    List<double> tarif;
    if (pphList != null && pphList.isNotEmpty) {
      tarif = pphList.map((e) {
        if (e is num) return e.toDouble();
        return double.tryParse(e.toString()) ?? 0.0;
      }).toList();
    } else {
      tarif = [0.05, 0.15, 0.25, 0.30, 0.35];
    }

    List<int> batas = [60000000, 250000000, 500000000, 5000000000];

    double pajak = 0.0;
    List<String> rincian = [];

    for (int i = 0; i < tarif.length; i++) {
      double lower = (i == 0) ? 0 : batas[i - 1].toDouble();
      double upper = (i < batas.length) ? batas[i].toDouble() : double.infinity;

      if (penghasilan > lower) {
        double kena = (penghasilan < upper ? penghasilan : upper) - lower;
        double pajakLapisan = kena * tarif[i];
        pajak += pajakLapisan;

        rincian.add("Lapisan ${i + 1} (${_fmtPercentPlain(tarif[i])}%) = ${formatRupiah.format(pajakLapisan)}");
      }
    }

    return {"total": pajak, "rincian": rincian};
  }

  RichText _formatHasilText(String text) {
    List<TextSpan> spans = [];
    List<String> lines = text.split('\n');

    for (var line in lines) {
      spans.add(TextSpan(text: line + "\n", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: line.contains("Total =") ? FontWeight.bold : FontWeight.normal)));
    }

    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kalkulator Pajak"), backgroundColor: Colors.blue.shade800, centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DropdownButtonFormField<String>(
              value: _jenisPajak,
              icon: _isAdmin ? const Icon(Icons.settings) : const Icon(Icons.arrow_drop_down),
              selectedItemBuilder: (context) {
                return _pajakIcons.keys.map((jenis) {
                  return Row(children: [Icon(_pajakIcons[jenis], color: _pajakColors[jenis]), const SizedBox(width: 8), Text(jenis)]);
                }).toList();
              },
              items: _pajakIcons.keys.map((jenis) {
                return DropdownMenuItem(
                    value: jenis,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [Icon(_pajakIcons[jenis], color: _pajakColors[jenis]), const SizedBox(width: 8), Text(jenis)]),
                      if (_isAdmin)
                        IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.settings, size: 18), onPressed: () async {
                          final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEditRegulasiPage(jenisPajak: jenis)));
                          if (updated == true) {
                            await _loadSettings();
                            setState(() {});
                          }
                        })
                    ]));
              }).toList(),
              onChanged: (v) => setState(() => _jenisPajak = v!),
              decoration: const InputDecoration(labelText: "Pilih Jenis Pajak", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _nilaiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Masukkan Penghasilan Pertahun",
                border: const OutlineInputBorder(),
                prefixIcon: Container(width: 45, alignment: Alignment.center, child: const Text("Rp", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: _hitungPajak,
                icon: Icon(_pajakIcons[_jenisPajak]),
                label: const Text("Hitung & Simpan"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              ),
            ),

            const SizedBox(height: 20),

            if (_hasilRincian.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.shade200)),
                child: _formatHasilText(_hasilRincian),
              ),
          ]),
        ),
      ),
    );
  }
}