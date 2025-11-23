import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHolidayService {
  static Future<List<dynamic>> getHolidays() async {
    final url = Uri.parse("https://api-harilibur.vercel.app/api");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data hari libur");
    }
  }
}
