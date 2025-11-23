import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/db_helper.dart';
import '../services/api_holiday_service.dart';
import '../services/notification_service.dart';   // ← tambahkan ini

class PengingatPembayaranPage extends StatefulWidget {
  @override
  _PengingatPembayaranPageState createState() =>
      _PengingatPembayaranPageState();
}

class _PengingatPembayaranPageState extends State<PengingatPembayaranPage> {
  List<Map<String, dynamic>> reminders = [];
  List<dynamic> holidays = [];
  bool loadingHoliday = true;

  @override
  void initState() {
    super.initState();
    loadReminders();
    loadHolidays();
  }

  Future<void> loadReminders() async {
    reminders = await DBHelper.getReminders();
    setState(() {});
  }

  Future<void> loadHolidays() async {
    try {
      final data = await ApiHolidayService.getHolidays();
      setState(() {
        holidays = data;
        loadingHoliday = false;
      });
    } catch (e) {
      setState(() => loadingHoliday = false);
    }
  }

  // =============================
  // ADD REMINDER + NOTIFIKASI
  // =============================
  Future<void> addReminder() async {
    final controllerJudul = TextEditingController();
    DateTime? pickedDate;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Tambah Pengingat"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controllerJudul,
                      decoration: const InputDecoration(labelText: "Judul"),
                    ),
                    const SizedBox(height: 12),

                    // Tanggal
                    Text(
                      pickedDate == null
                          ? "Belum pilih tanggal"
                          : "Tanggal: ${DateFormat('yyyy-MM-dd').format(pickedDate!)}",
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                          initialDate: DateTime.now(),
                        );

                        if (date != null) {
                          setStateDialog(() {
                            pickedDate = date;
                          });
                        }
                      },
                      child: const Text("Pilih Tanggal"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (controllerJudul.text.isEmpty || pickedDate == null) {
                      return;
                    }

                    final data = {
                      "judul": controllerJudul.text,
                      "tanggal": DateFormat('yyyy-MM-dd').format(pickedDate!),
                      "isDone": 0
                    };

                    // SIMPAN ke SQLite
                    final reminderId = await DBHelper.insertReminder(data);

                    // =============================
                    // NOMOR 3 — SCHEDULE NOTIFIKASI
                    // =============================
                    await NotificationService.scheduleReminder(
                      id: reminderId,
                      title: controllerJudul.text,
                      date: pickedDate!,     // ← tanggal yang dipilih user
                    );

                    await loadReminders();
                    Navigator.pop(context);
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // =============================
  // UI
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengingat Pembayaran Pajak")),
      floatingActionButton: FloatingActionButton(
        onPressed: addReminder,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Hari Libur Nasional",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          if (loadingHoliday)
            const Center(child: CircularProgressIndicator())
          else if (holidays.isEmpty)
            const Text("Tidak ada data hari libur.")
          else
            ...holidays.map((h) {
              return Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.red),
                  title: Text(h["holiday_name"]),
                  subtitle: Text(h["holiday_date"]),
                ),
              );
            }).toList(),

          const SizedBox(height: 20),

          const Text(
            "Pengingat Anda",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...reminders.map((r) {
            return Card(
              child: ListTile(
                title: Text(r["judul"]),
                subtitle: Text(r["tanggal"]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await DBHelper.deleteReminder(r["id"]);
                    loadReminders();
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
