import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notif =
  FlutterLocalNotificationsPlugin();

  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required DateTime date,
  }) async {
    await notif.zonedSchedule(
      id,
      title,
      'Waktunya bayar pajak!',
      tz.TZDateTime.from(date, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }
}
