import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Panduan_Model.dart';

class PanduanService {
  final String baseUrl = "https://6922a88b09df4a492322f92e.mockapi.io/panduan";

  Future<List<PanduanModel>> getPanduan() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => PanduanModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data panduan");
    }
  }

  Future<bool> createPanduan(String title, String desc, String content) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": desc,
        "content": content,
      }),
    );

    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> updatePanduan(String id, String title, String desc, String content) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": desc,
        "content": content,
      }),
    );

    return res.statusCode == 200;
  }

  Future<bool> deletePanduan(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    return res.statusCode == 200;
  }
}
