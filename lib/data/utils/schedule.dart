import 'package:habit_tracker/main.dart'; // pastikan path-nya sesuai
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// Fungsi untuk menghasilkan ID notifikasi yang konsisten
int generateNotificationId(String input) {
  int hash = 5381;
  for (int i = 0; i < input.length; i++) {
    hash = ((hash << 5) + hash) + input.codeUnitAt(i);
  }
  return hash & 0x7fffffff; // Pastikan ID positif
}

// Fungsi untuk membatalkan notifikasi yang sudah dijadwalkan
Future<void> cancelHabitNotification(int notificationId) async {
  print("Attempting to cancel notification with ID: $notificationId");
  await flutterLocalNotificationsPlugin.cancel(notificationId);
  print("Cancelled notification with ID: $notificationId");
}

Future<void> scheduleNotification({
  required String habitId,
  required String habitTitle,
  required DateTime scheduledTime,
  required String message,
  int? notificationId, // jika tidak diberikan, akan dihasilkan dari habitId
}) async {
  // Gunakan generateNotificationId jika notificationId tidak diberikan
  int notifId = notificationId ?? generateNotificationId(habitId);

  // Notifikasi di Android
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'habit_channel_id', // ID channel
    'Habit Notifications', // Nama channel
    channelDescription: 'Channel untuk reminder habit',
    importance: Importance.high,
    priority: Priority.high,
  );

  // Notifikasi di iOS
  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails();

  // Gabungkan Android & iOS
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  print("Scheduling notification with ID: $notifId");
  print("Scheduled time: $scheduledTime");
  print("Message: $message");

  // Batalkan notifikasi sebelumnya dengan ID yang sama
  await cancelHabitNotification(notifId);

  // Jadwalkan notifikasi baru (dengan notifikasi satu kali, bukan recurring)
  await flutterLocalNotificationsPlugin.zonedSchedule(
    notifId, // ID notifikasi unik
    'Habit Tracker Reminder', // Title
    message, // Body
    tz.TZDateTime.from(scheduledTime, tz.local),
    platformChannelSpecifics,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
    payload: habitId, // Payload untuk identifikasi habit
  );
  
  print("Notification with ID: $notifId scheduled successfully");
}
