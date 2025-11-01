
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPerhitunganPage extends StatefulWidget {
  const RiwayatPerhitunganPage({super.key});

  @override
  State<RiwayatPerhitunganPage> createState() => _RiwayatPerhitunganPageState();
}

class _RiwayatPerhitunganPageState extends State<RiwayatPerhitunganPage> {
  List<String> _riwayat = [];

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _riwayat = prefs.getStringList('riwayat') ?? [];
    });
  }

  Future<void> _hapusSatuRiwayat(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> riwayat = prefs.getStringList('riwayat') ?? [];
    riwayat.removeAt(index);
    await prefs.setStringList('riwayat', riwayat);
    setState(() {
      _riwayat = riwayat;
    });
  }

  Future<void> _hapusSemuaRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('riwayat');
    setState(() {
      _riwayat.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Perhitungan"),
        backgroundColor: Colors.blue.shade800,
        actions: [
          if (_riwayat.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: "Hapus Semua",
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Hapus Semua Riwayat?"),
                    content:
                    const Text("Semua data riwayat akan dihapus permanen."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  _hapusSemuaRiwayat();
                }
              },
            ),
        ],
      ),
      body: _riwayat.isEmpty
          ? const Center(
        child: Text(
          "Belum ada riwayat perhitungan",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _riwayat.length,
        itemBuilder: (context, index) {
          final data = _riwayat[index];
          final waktu = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

          // Pisahkan informasi
          final parts = data.split('|');
          String jenis = "";
          String nilai = "";
          String pajak = "";

          if (parts.isNotEmpty) {
            final main = parts[0].split('-');
            if (main.length >= 2) {
              jenis = main[0].trim();
              nilai = main[1].replaceAll("Nilai:", "").trim();
            }
            if (parts.length >= 2) {
              pajak = parts[1].replaceAll("Pajak:", "").trim();
            }
          }

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.receipt_long, color: Colors.blue),
              ),
              title: Text(
                "$jenis • $pajak",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Input: $nilai",
                        style: const TextStyle(color: Colors.black54)),
                    Text("Waktu: $waktu",
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.blue),
                onSelected: (value) {
                  if (value == 'hapus') {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Hapus Riwayat Ini?"),
                        content: Text("Ingin menghapus data '$jenis'?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _hapusSatuRiwayat(index);
                            },
                            child: const Text(
                              "Hapus",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'hapus',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Hapus"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
