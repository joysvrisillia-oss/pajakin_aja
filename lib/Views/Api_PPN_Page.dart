import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiPPNPage extends StatefulWidget {
  const ApiPPNPage({super.key});

  @override
  State<ApiPPNPage> createState() => _ApiPPNPageState();
}

class _ApiPPNPageState extends State<ApiPPNPage> {
  String hasil = "Memuat data...";

  Future<void> getPPN() async {
    final url = Uri.parse("https://api.vatcomply.com/rates");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rates = data["rates"];

      // tampilkan 5 negara saja
      List<String> negara = ["ID", "SG", "MY", "JP", "KR"];
      String text = "";

      for (var kode in negara) {
        var n = rates[kode];
        text += "${n["name"]}: ${n["standard_rate"]}%\n";
      }

      setState(() => hasil = text);
    } else {
      setState(() => hasil = "Gagal mengambil data API.");
    }
  }

  @override
  void initState() {
    super.initState();
    getPPN();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Tarif PPN Dunia (API)"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            hasil,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
