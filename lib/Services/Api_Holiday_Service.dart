import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHolidayService {
  static Future<List<dynamic>> getHolidays(String year, String country) async {
    final url = Uri.parse(
        "https://date.nager.at/api/v3/PublicHolidays/$year/$country");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal mengambil data holiday");
    }
  }
}
