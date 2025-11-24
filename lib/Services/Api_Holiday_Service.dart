import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Holiday_Model.dart'; // <<< PENTING: Import Model Holiday

class ApiHolidayService {
  // Ubah menjadi method instance atau tetap static, tapi ubah return type
  static Future<List<Holiday>> getHolidays() async {
    // API ini mengembalikan data hari libur untuk tahun berjalan
    final url = Uri.parse("https://api-harilibur.vercel.app/api");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 1. Decode JSON menjadi List<Map<String, dynamic>>
      List<dynamic> data = jsonDecode(response.body);

      // 2. Mapping data List<dynamic> menjadi List<Holiday>
      // API yang Anda gunakan memiliki format data:
      // [{"holiday_date": "YYYY-MM-DD", "holiday_name": "Nama Hari Libur", "is_national_holiday": true/false}]

      return data.map((json) {
        return Holiday.fromJson({
          // Kunci di API: 'holiday_date' dan 'holiday_name'
          'date': json['holiday_date'],
          'name': json['holiday_name'],
        });
      }).toList();
    } else {
      // Lebih baik menggunakan log atau mencetak error daripada langsung throw Exception
      print("Failed to load holidays with status code: ${response.statusCode}");
      return []; // Kembalikan list kosong jika gagal
    }
  }
}