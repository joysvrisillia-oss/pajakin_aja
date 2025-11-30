import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Holiday_Model.dart';

class ApiHolidayService {
  static Future<List<Holiday>> getHolidays() async {
    final url = Uri.parse("https://api-harilibur.vercel.app/api");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      return data.map((json) {
        return Holiday.fromJson({
          'date': json['holiday_date'],
          'name': json['holiday_name'],
        });
      }).toList();
    } else {
      print("Failed to load holidays with status code: ${response.statusCode}");
      return [];
    }
  }
}