// File 1: lib/Views/Admin_Edit_Regulasi_Page.dart
// Halaman edit regulasi — input/display menggunakan PERSEN (mis. 0.5% ditulis 0.5)

import 'package:flutter/material.dart';
import '../Database/db_helper.dart';

class AdminEditRegulasiPage extends StatefulWidget {
  final String jenisPajak;
  const AdminEditRegulasiPage({super.key, required this.jenisPajak});

  @override
  State<AdminEditRegulasiPage> createState() => _AdminEditRegulasiPageState();
}

class _AdminEditRegulasiPageState extends State<AdminEditRegulasiPage> {
  final TextEditingController _pphController = TextEditingController();
  final TextEditingController _umkmController = TextEditingController();
  final TextEditingController _pbbController = TextEditingController();
  final TextEditingController _ppnController = TextEditingController();

  bool _loading = true;
  Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final s = await DBHelper.getTaxSettings();
    setState(() {
      _settings = s;

      // PPH: convert decimals (0.05) -> persen (5)
      if (s.containsKey('pph')) {
        try {
          final list = (s['pph'] as List).map((e) {
            final d = (e is num) ? e.toDouble() : double.tryParse(e.toString()) ?? 0.0;
            return (d * 100).toString(); // show e.g. "5.0"
          }).toList();
          _pphController.text = list.join(',');
        } catch (_) {
          _pphController.text = '';
        }
      }

      // UMKM, PBB, PPN: convert decimal -> persen (e.g. 0.005 -> 0.5)
      if (s.containsKey('umkm')) _umkmController.text = ((s['umkm'] as num).toDouble() * 100).toString();
      if (s.containsKey('pbb')) _pbbController.text = ((s['pbb'] as num).toDouble() * 100).toString();
      if (s.containsKey('ppn')) _ppnController.text = ((s['ppn'] as num).toDouble() * 100).toString();

      _loading = false;
    });
  }

  // Helper: parse input that is a percent string (like "0.5" or "0.5%" or "11") -> decimal (0.005 or 0.11)
  double _parsePercentToDecimal(String input) {
    final s = input.replaceAll('%', '').trim();
    final v = double.tryParse(s) ?? 0.0;
    return v / 100.0;
  }

  Future<void> _save() async {
    final current = Map<String, dynamic>.from(_settings);

    if (widget.jenisPajak.toLowerCase().contains('pph')) {
      final raw = _pphController.text.trim();
      final list = raw.isEmpty
          ? <double>[]
          : raw.split(',').map((s) {
        final parsed = double.tryParse(s.trim().replaceAll('%', '')) ?? 0.0;
        return parsed / 100.0; // store decimal
      }).toList();
      if (list.isNotEmpty) current['pph'] = list;
    } else if (widget.jenisPajak.toLowerCase().contains('umkm')) {
      final raw = _umkmController.text.trim();
      current['umkm'] = _parsePercentToDecimal(raw);
    } else if (widget.jenisPajak.toLowerCase().contains('pbb') ||
        widget.jenisPajak.toLowerCase().contains('ppn') ||
        widget.jenisPajak.toLowerCase().contains('lainnya')) {
      final pbb = _parsePercentToDecimal(_pbbController.text.trim());
      final ppn = _parsePercentToDecimal(_ppnController.text.trim());
      current['pbb'] = pbb;
      current['ppn'] = ppn;
    }

    await DBHelper.updateTaxSettings(current);
    Navigator.pop(context, true);
  }

  Future<void> _resetToDefault() async {
    final defaultSettings = {
      "pph": [0.05, 0.15, 0.25, 0.30, 0.35],
      "umkm": 0.005,
      "pbb": 0.001,
      "ppn": 0.11,
      "labels": {
        "pph": "PPh Pribadi",
        "umkm": "Pajak Bisnis (UMKM)",
        "lainnya": "Pajak Lainnya (PBB & PPN)"
      }
    };
    await DBHelper.updateTaxSettings(defaultSettings);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      if (widget.jenisPajak.toLowerCase().contains('pph')) {
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PPh Pribadi — masukkan tarif lapisan (pisahkan dengan koma). Format: persen (mis. 5,15,25)") ,
            const SizedBox(height: 8),
            TextField(
              controller: _pphController,
              decoration: const InputDecoration(
                hintText: "contoh: 5,15,25,30,35",
                border: OutlineInputBorder(),
                labelText: "Tarif lapisan (persen)",
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        );
      } else if (widget.jenisPajak.toLowerCase().contains('umkm')) {
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pajak Bisnis (UMKM) — masukkan tarif (persen, contoh 0.5 untuk 0.5%)"),
            const SizedBox(height: 8),
            TextField(
              controller: _umkmController,
              decoration: const InputDecoration(
                hintText: "contoh: 0.5 untuk 0.5%",
                border: OutlineInputBorder(),
                labelText: "Tarif UMKM (persen)",
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        );
      } else {
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PBB & PPN — masukkan pbb dan ppn (persen, contoh: 0.1 untuk 0.1%, 11 untuk 11%)"),
            const SizedBox(height: 8),
            TextField(
              controller: _pbbController,
              decoration: const InputDecoration(
                hintText: "contoh: 0.1 untuk 0.1%",
                border: OutlineInputBorder(),
                labelText: "Tarif PBB (persen)",
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ppnController,
              decoration: const InputDecoration(
                hintText: "contoh: 11 untuk 11%",
                border: OutlineInputBorder(),
                labelText: "Tarif PPN (persen)",
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Regulasi - ${widget.jenisPajak}"),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset default",
            onPressed: () async {
              final ok = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Reset ke default?"),
                  content: const Text("Mengembalikan regulasi ke nilai default awal aplikasi."),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(_, false), child: const Text("Batal")),
                    ElevatedButton(onPressed: () => Navigator.pop(_, true), child: const Text("Reset")),
                  ],
                ),
              );
              if (ok == true) _resetToDefault();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              body,
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                child: const Text("Simpan Perubahan"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Batal"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
