import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';
import 'package:http/http.dart' as http;

class TaxReminderPage extends StatefulWidget {
  const TaxReminderPage({super.key});

  @override
  State<TaxReminderPage> createState() => _TaxReminderPageState();
}

class _TaxReminderPageState extends State<TaxReminderPage> {
  final FlutterLocalNotificationsPlugin notifications =
  FlutterLocalNotificationsPlugin();

  DateTime? selectedDate;
  String holidayMessage = "";

  @override
  void initState() {
    super.initState();
    _initNotifications();
    tz.initializeTimeZones();
  }

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await notifications.initialize(
      const InitializationSettings(android: android),
    );
  }

  Future<Map<String, dynamic>?> getHolidayInfo(DateTime date) async {
    final url = Uri.parse(
      "https://api-harilibur.vercel.app/api?month=${date.month}&year=${date.year}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      for (var item in data) {
        if (item["holiday_date"] ==
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}") {
          return {
            "name": item["holiday_name"],
            "is_national": item["is_national_holiday"]
          };
        }
      }
    }
    return null;
  }

  Future<DateTime> adjustDate(DateTime date) async {
    final holiday = await getHolidayInfo(date);

    if (holiday != null) {
      return date.add(const Duration(days: 1));
    }
    return date;
  }

  Future<void> scheduleReminder(DateTime date, String message) async {
    final tzDate = tz.TZDateTime.from(date, tz.local);

    await notifications.zonedSchedule(
      0,
      'Pengingat Pajak',
      message,
      tzDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'tax_channel',
          'Tax Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Set Pengingat Pajak"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Atur Tanggal Pembayaran Pajak",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2035),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                    holidayMessage = "";
                  });
                }
              },
              child: const Text("Pilih Tanggal"),
            ),

            const SizedBox(height: 20),

            if (selectedDate != null)
              Text(
                "Tanggal dipilih: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                style: const TextStyle(fontSize: 16),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: selectedDate == null
                  ? null
                  : () async {
                final holiday = await getHolidayInfo(selectedDate!);

                DateTime finalDate = await adjustDate(selectedDate!);

                String message = "";

                if (holiday != null) {
                  message =
                  "Tanggal ${selectedDate!.day} adalah ${holiday["name"]}. Pembayaran pajak dimundurkan ke tanggal ${finalDate.day}.";
                } else {
                  message =
                  "Jangan lupa bayar pajak tanggal ${selectedDate!.day}.";
                }

                setState(() {
                  holidayMessage = message;
                });

                finalDate =
                    finalDate.add(const Duration(hours: 9));

                await scheduleReminder(finalDate, message);
              },
              child: const Text("Set Pengingat"),
            ),

            const SizedBox(height: 20),

            Text(
              holidayMessage,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
