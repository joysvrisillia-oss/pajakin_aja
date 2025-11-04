import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database_backup/db_helper_backup.dart';
import '../Models_backup/pajak_model_backup.dart';

class KalkulatorViewModel extends ChangeNotifier {
  final TextEditingController nilaiController = TextEditingController();
  String jenisPajak = 'PPh Pribadi';
  String hasilRincian = "";
  double hasilPajak = 0.0;

  final formatRupiah =
  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void setJenisPajak(String value) {
    jenisPajak = value;
    notifyListeners();
  }

  Future<void> hitungDanSimpan() async {
    double nilai = double.tryParse(nilaiController.text) ?? 0.0;
    if (nilai <= 0) return;

    double pajak = 0.0;
    String rincian = "";

    if (jenisPajak == 'PPh Pribadi') {
      final hasil = _hitungPPhPribadiDetail(nilai);
      pajak = hasil['total'];
      List<String> lapisanList = hasil['rincian'];
      rincian = "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n\n"
          "PPh Pribadi (progresif UU HPP 2025)\n"
          "${lapisanList.join("\n")}\n"
          "Total = ${formatRupiah.format(pajak)}";
    } else if (jenisPajak == 'Pajak Bisnis (UMKM)') {
      pajak = nilai * 0.005;
      rincian = "Rincian Perhitungan:\n"
          "Dasar Nilai : ${formatRupiah.format(nilai)}\n"
          "Pajak UMKM (0.5%) = ${formatRupiah.format(pajak)}\n"
          "Total = ${formatRupiah.format(pajak)}";
    } else if (jenisPajak == 'Pajak Lainnya (PBB & PPN)') {
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

    hasilPajak = pajak;
    hasilRincian = rincian;
    notifyListeners();

    await DBHelper.insertPajak(PajakModel(
      jenisPajak: jenisPajak,
      nilai: nilai,
      pajak: pajak,
      waktu: DateTime.now().toString(),
    ));
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
}
