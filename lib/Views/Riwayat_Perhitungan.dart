import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/db_helper.dart';
import '../Models/pajak_model.dart';

class RiwayatPerhitunganPage extends StatefulWidget {
  const RiwayatPerhitunganPage({super.key});

  @override
  State<RiwayatPerhitunganPage> createState() => _RiwayatPerhitunganPageState();
}

class _RiwayatPerhitunganPageState extends State<RiwayatPerhitunganPage> {
  List<PajakModel> _riwayat = [];
  final formatRupiah =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final Map<String, IconData> _pajakIcons = {
    'PPh Pribadi': Icons.person,
    'Pajak Bisnis (UMKM)': Icons.business_center,
    'Pajak Lainnya (PBB & PPN)': Icons.receipt_long,
  };

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    final data = await DBHelper.getAllPajak();
    setState(() {
      _riwayat = data.reversed.toList(); // terbaru di atas
    });
  }

  Future<void> _hapusSatuRiwayat(int id) async {
    await DBHelper.deletePajak(id);
    await _loadRiwayat();
  }

  Future<void> _hapusSemuaRiwayat() async {
    await DBHelper.deleteAll();
    setState(() => _riwayat.clear());
  }

  void _tampilkanDetail(PajakModel item) {
    final waktu = DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.tryParse(item.waktu) ?? DateTime.now());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Detail ${item.jenisPajak}",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nilai Dasar: ${formatRupiah.format(item.nilai)}"),
            const SizedBox(height: 6),
            Text("Pajak: ${formatRupiah.format(item.pajak)}"),
            const SizedBox(height: 6),
            Text("Waktu: $waktu"),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Tutup")),
        ],
      ),
    );
  }

  Color _getColor(String jenis) {
    if (jenis.contains('PPh')) return Colors.blue.shade700;
    if (jenis.contains('UMKM')) return Colors.green.shade700;
    if (jenis.contains('PPN') || jenis.contains('PBB')) {
      return Colors.purple.shade700;
    }
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Perhitungan"),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (_riwayat.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: "Hapus Semua",
              onPressed: () async {
                final konfirmasi = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Hapus Semua Riwayat?"),
                    content: const Text(
                        "Semua hasil perhitungan akan dihapus permanen."),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text("Batal")),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          "Hapus",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (konfirmasi == true) _hapusSemuaRiwayat();
              },
            ),
        ],
      ),
      body: _riwayat.isEmpty
          ? const Center(
        child: Text(
          "Belum ada riwayat perhitungan",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _riwayat.length,
        itemBuilder: (context, index) {
          final item = _riwayat[index];
          final icon = _pajakIcons[item.jenisPajak] ?? Icons.receipt_long;
          final warna = _getColor(item.jenisPajak);
          final waktu = DateFormat('dd/MM/yyyy HH:mm')
              .format(DateTime.tryParse(item.waktu) ?? DateTime.now());

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: warna.withAlpha(25),
                child: Icon(icon, color: warna),
              ),
              title: Text(
                item.jenisPajak,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nilai: ${formatRupiah.format(item.nilai)}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Pajak: ${formatRupiah.format(item.pajak)}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      "Waktu: $waktu",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.blue),
                onSelected: (value) {
                  if (value == 'detail') {
                    _tampilkanDetail(item);
                  } else if (value == 'hapus') {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Hapus Riwayat Ini?"),
                        content: Text(
                            "Ingin menghapus ${item.jenisPajak}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _hapusSatuRiwayat(item.id!);
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

