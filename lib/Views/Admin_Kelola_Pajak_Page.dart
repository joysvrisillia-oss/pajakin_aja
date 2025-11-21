import 'package:flutter/material.dart';
import '../Database/db_helper.dart';
import 'Kelola_Pajak_Setting.dart';

class AdminKelolaPajakPage extends StatefulWidget {
  const AdminKelolaPajakPage({super.key});

  @override
  State<AdminKelolaPajakPage> createState() => _AdminKelolaPajakPageState();
}

class _AdminKelolaPajakPageState extends State<AdminKelolaPajakPage> {
  Map<String, dynamic> settings = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    settings = await DBHelper.getTaxSettings();
    setState(() => loading = false);
  }

  void openEditModal() {
    showDialog(
      context: context,
      builder: (_) => KelolaPajakSetting(   // ← FIX 1
        settings: settings,
        onSave: (newSettings) async {
          await DBHelper.updateTaxSettings(newSettings);
          await loadSettings();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tarif pajak berhasil diperbarui")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Kelola Perhitungan Pajak")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Perhitungan Pajak"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tarif Pajak Saat Ini:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.blue),
                    onPressed: openEditModal,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            buildSettingRow("PPh Pribadi", settings["pph"].toString()),
            buildSettingRow("UMKM", (settings["umkm"] * 100).toString() + "%"),
            buildSettingRow("PBB", (settings["pbb"] * 100).toString() + "%"),
            buildSettingRow("PPN", (settings["ppn"] * 100).toString() + "%"),
          ],
        ),
      ),
    );
  }

  Widget buildSettingRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
