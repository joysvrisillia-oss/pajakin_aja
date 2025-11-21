import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHolidayPage extends StatefulWidget {
  const ApiHolidayPage({super.key});

  @override
  State<ApiHolidayPage> createState() => _ApiHolidayPageState();
}

class _ApiHolidayPageState extends State<ApiHolidayPage> {
  List holidays = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getHolidays();
  }

  Future<void> getHolidays() async {
    final url = Uri.parse(
        "https://api-harilibur.vercel.app/api?year=${DateTime.now().year}");

    final res = await http.get(url);

    if (res.statusCode == 200) {
      setState(() {
        holidays = jsonDecode(res.body);
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hari Libur Nasional"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: holidays.length,
        itemBuilder: (context, i) {
          final h = holidays[i];
          return Card(
            child: ListTile(
              title: Text(h["holiday_name"] ?? ""),
              subtitle: Text(h["holiday_date"] ?? ""),
            ),
          );
        },
      ),
    );
  }
}
