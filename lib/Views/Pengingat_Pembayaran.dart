import 'package:flutter/material.dart';
import '../Services/Api_Holiday_Service.dart';
import '../Models/Holiday_Model.dart';
import 'package:intl/intl.dart';

// --- WIDGET UTAMA (Stateful) ---
class PengingatPembayaranPage extends StatefulWidget {
  const PengingatPembayaranPage({super.key});

  @override
  State<PengingatPembayaranPage> createState() => _PengingatPembayaranPageState();
}

class _PengingatPembayaranPageState extends State<PengingatPembayaranPage> {
  // Future yang sekarang digunakan untuk mengambil data dan menyimpannya
  Future<List<Holiday>>? _holidaysFuture;

  // State untuk tanggal batas akhir
  DateTime _selectedDeadlineDate = DateTime(2025, 12, 31);

  // State untuk menyimpan data Hari Libur setelah fetch berhasil
  List<Holiday> _holidays = [];

  // State untuk menyimpan catatan dinamis
  String _noteMessage = 'Memuat data hari libur...';

  @override
  void initState() {
    super.initState();
    // Memanggil API dan memproses hasilnya
    _holidaysFuture = ApiHolidayService.getHolidays().then((data) {
      // 1. Simpan data Hari Libur ke state
      _holidays = data;
      // 2. Inisialisasi catatan awal
      _generateNote(_selectedDeadlineDate);
      return data;
    }).catchError((error) {
      // Tangani error jika gagal
      _noteMessage = 'Gagal memuat hari libur: $error';
      return <Holiday>[];
    });
  }


  void _generateNote(DateTime deadline) {
    // Format tanggal deadline ke format YYYY-MM-DD untuk pencarian di data API
    final deadlineString = DateFormat('yyyy-MM-dd').format(deadline);

    // Cari apakah tanggal jatuh tempo adalah hari libur
    final isHoliday = _holidays.firstWhere(
          (h) => h.date == deadlineString,
      orElse: () => Holiday(date: '', name: ''),
    );

    String newNote;
    if (isHoliday.date.isNotEmpty) {
      // Jika tanggal jatuh tempo adalah Hari Libur
      // Asumsi: Mundur 1 hari kerja (logika ini harus diperbaiki untuk melewati weekend/libur berturut-turut)
      final nextDay = deadline.add(const Duration(days: 1));
      final nextDayFormatted = DateFormat('dd').format(nextDay);
      final holidayName = isHoliday.name;

      newNote = 'Tanggal ${DateFormat('dd').format(deadline)} adalah *$holidayName* (Hari Libur Nasional). Pembayaran pajak yang jatuh tempo pada tanggal tersebut, secara otomatis dimundurkan ke tanggal $nextDayFormatted.';
    } else if (deadline.weekday == DateTime.saturday || deadline.weekday == DateTime.sunday) {
      // Jika jatuh tempo Sabtu atau Minggu
      int daysToAdd = (deadline.weekday == DateTime.saturday) ? 2 : 1; // Jika Sabtu +2, Jika Minggu +1
      final nextDay = deadline.add(Duration(days: daysToAdd));
      final nextDayFormatted = DateFormat('dd').format(nextDay);
      newNote = 'Tanggal ${DateFormat('dd-MM').format(deadline)} jatuh pada *akhir pekan*. Pembayaran otomatis dimundurkan ke hari Senin tanggal $nextDayFormatted.';
    } else {
      newNote = 'Tanggal batas akhir pembayaran adalah *hari kerja*. Tidak ada sinkronisasi hari libur yang diterapkan.';
    }

    // Perbarui state catatan
    setState(() {
      _noteMessage = newNote;
    });
  }

  // Fungsi Callback yang diperbarui untuk memperbarui tanggal DAN catatan
  void _updateDeadlineDate(DateTime newDate) {
    setState(() {
      _selectedDeadlineDate = newDate;
    });
    // Panggil fungsi untuk menghasilkan catatan baru
    _generateNote(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengingat Pembayaran Pajak',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.lightBlue.shade300,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian 1: Kartu Pengingat ---
              PaymentReminderCard(
                deadlineDate: _selectedDeadlineDate,
                onDateSelected: _updateDeadlineDate,
                noteMessage: _noteMessage,
              ),

              const SizedBox(height: 20),

              // --- Bagian 2: Header Daftar Hari Libur ---
              const Text(
                'Daftar Hari Libur Nasional Tahun Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),

              // FutureBuilder untuk Hari Libur
              FutureBuilder<List<Holiday>>(
                future: _holidaysFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Gagal mengambil data hari libur: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      children: snapshot.data!.map((holiday) {
                        return HolidayCard(holiday: holiday);
                      }).toList(),
                    );
                  } else {
                    return const Text(
                      'Tidak ada hari libur nasional ditemukan tahun ini.',
                      style: TextStyle(color: Colors.white70),
                    );
                  }
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- 1. Kartu Hari Libur (Tidak Ada Perubahan) ---
class HolidayCard extends StatelessWidget {
  final Holiday holiday;

  const HolidayCard({super.key, required this.holiday});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF1976D2),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holiday.date,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    holiday.name,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// --- 2. Kartu Pengingat Pembayaran (Direvisi) ---
class PaymentReminderCard extends StatelessWidget {
  final DateTime deadlineDate;
  final Function(DateTime) onDateSelected;

  final String noteMessage;

  const PaymentReminderCard({
    super.key,
    required this.deadlineDate,
    required this.onDateSelected,
    required this.noteMessage,
  });

  // Helper untuk memformat DateTime menjadi String D-M-Y
  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // Fungsi untuk menampilkan DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deadlineDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      helpText: 'Pilih Batas Akhir Pembayaran',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null && picked != deadlineDate) {
      onDateSelected(picked);
    }
  }

  // 🆕 Fungsi untuk menampilkan dialog "Set Pengingat Berhasil"
  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil!'),
          content: const Text(
            'Set pengingat berhasil.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alur Tanggal Pembayaran Pajak',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Color(0xFF303F9F),
              ),
            ),
            const Divider(height: 25, thickness: 1.5, color: Colors.grey),

            // Item Batas Akhir
            _buildReminderItem(
              context,
              'Batas Akhir Pelaporan & Pembayaran',
              _formatDate(deadlineDate),
              Colors.red.shade700,
            ),
            const SizedBox(height: 8),

            // Tombol untuk Mengubah Tanggal
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                label: const Text('Ubah Tanggal', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),

            // Catatan Sinkronisasi Hari Libur
            _buildReminderNote(noteMessage),

            const SizedBox(height: 18),

            // 🆕 Tombol "SET PENGINGAT"
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                // 🆕 Panggil dialog sukses saat tombol diklik
                onPressed: () {
                  _showSuccessDialog(context);
                },
                // 🆕 Mengganti ikon dan label
                icon: const Icon(Icons.notifications_active_outlined, size: 18),
                label: const Text('SET PENGINGAT', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk baris detail batas akhir (memperbaiki RenderFlex overflow)
  Widget _buildReminderItem(BuildContext context, String title, String date, Color color) {
    return Row(
      children: [
        // FIX: BUNGKUS DENGAN Expanded
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          date,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: color,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  // Helper untuk box catatan
  Widget _buildReminderNote(String note) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Catatan Hari Libur: $note',
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}