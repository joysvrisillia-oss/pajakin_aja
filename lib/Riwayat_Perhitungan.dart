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
  final formatRupiah = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final Map<String, IconData> _pajakIcons = {
    'PPh Pribadi': Icons.person,
    'Pajak Bisnis (UMKM)': Icons.business_center,
    'Pajak Lainnya (PBB & PPN)': Icons.receipt_long,
  };

  Color _getColor(String jenis) {
    if (jenis.contains('PPh Pribadi')) {
      return Colors.blue.shade700;
    } else if (jenis.contains('Pajak Bisnis (UMKM)')) {
      return Colors.green.shade700;
    } else if (jenis.contains('Pajak Lainnya (PBB & PPN)')) {
      return Colors.purple.shade700;
    }
    return Colors.blue;
  }

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> riwayat = prefs.getStringList('riwayat') ?? [];
    setState(() {
      _riwayat = riwayat.reversed.toList();
    });
  }

  Future<void> _hapusSatuRiwayat(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> riwayat = prefs.getStringList('riwayat') ?? [];
    riwayat.removeAt(_riwayat.length - 1 - index);
    await prefs.setStringList('riwayat', riwayat);
    setState(() {
      _riwayat = riwayat.reversed.toList();
    });
  }

  Future<void> _hapusSemuaRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('riwayat');
    setState(() {
      _riwayat.clear();
    });
  }

  void _tampilkanDetailRiwayat(String data) {
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

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Hasil Perhitungan ${jenis.split(' ')[0]}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rincian Perhitungan:\n"
                    "Dasar Nilai : $nilai\n\n"
                    "$jenis\n",
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              if (jenis == 'PPh Pribadi') ...[
                _buildLapisanItem("Lapisan 1 (5%)", "Rp 3.000.000"),
                _buildLapisanItem("Lapisan 2 (15%)", "Rp 750.000"),
                const SizedBox(height: 10),
              ],
              if (jenis == 'Pajak Bisnis (UMKM)') ...[
                Text(
                  "Pajak UMKM (0.5%) = $pajak",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 10),
              ],
              if (jenis == 'Pajak Lainnya (PBB & PPN)') ...[
                Text(
                  "PBB (0.1%) + PPN (11%) = $pajak\n\n"
                      "Rincian Perhitungan :\n"
                      "Dasar Nilai : $nilai\n"
                      "PBB (0.1%) = ${_hitungPBB(nilai)}\n"
                      "PPN (11%) = ${_hitungPPN(nilai)}",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 10),
              ],
              const Divider(),
              const SizedBox(height: 10),
              Text(
                "Total = $pajak",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Waktu: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Widget _buildLapisanItem(String lapisan, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(lapisan),
          ),
          Text(nilai),
        ],
      ),
    );
  }

  String _hitungPBB(String nilai) {
    String cleanNilai = nilai.replaceAll("Rp ", "").replaceAll(".", "");
    double nilaiDouble = double.tryParse(cleanNilai) ?? 0;
    double pbb = nilaiDouble * 0.001;
    return formatRupiah.format(pbb);
  }

  String _hitungPPN(String nilai) {
    String cleanNilai = nilai.replaceAll("Rp ", "").replaceAll(".", "");
    double nilaiDouble = double.tryParse(cleanNilai) ?? 0;
    double ppn = nilaiDouble * 0.11;
    return formatRupiah.format(ppn);
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
                    content: const Text("Semua data riwayat akan dihapus permanen."),
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

          Color warnaJenis = _getColor(jenis);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: () => _tampilkanDetailRiwayat(data),
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(_pajakIcons[jenis] ?? Icons.receipt_long, color: warnaJenis),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jenis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "• $pajak",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Input: $nilai", style: const TextStyle(color: Colors.black54)),
                    Text("Waktu: $waktu", style: const TextStyle(color: Colors.black54)),
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
                  } else if (value == 'detail') {
                    _tampilkanDetailRiwayat(data);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'detail',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Lihat Detail"),
                      ],
                    ),
                  ),
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
