import 'package:habit_tracker/data/utils/schedule.dart';
import 'package:intl/intl.dart';
import '../models/habit_model.dart';

void scheduleHabitReminders(HabitModel habit) {
  // Parsing "time" misalnya "08:30"
  final timeParts = habit.time.split(':');
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  final now = DateTime.now();
  var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

  // Jika waktu sudah lewat hari ini, jadwalkan untuk besok
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  // Notifikasi 15 menit sebelum waktu habit
  final reminder15Before = scheduledDate.subtract(const Duration(minutes: 10));

  // Debug log
  print("Scheduling notifications for habit '${habit.title}':");
  print(
      " - 15 minutes before: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(reminder15Before)}");
  print(
      " - Exact time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(scheduledDate)}");

  // Menghasilkan ID notifikasi yang konsisten dengan menambahkan suffix
  int notifIdBefore = generateNotificationId(habit.id + "_before");
  int notifIdExact = generateNotificationId(habit.id + "_exact");

  // Jadwalkan notifikasi 15 menit sebelum
  scheduleNotification(
    habitId: habit.id,
    habitTitle: habit.title,
    scheduledTime: reminder15Before,
    message:
        "Reminder: 10 menit lagi saatnya ${habit.title}. Ayo tetap disiplin!",
    notificationId: notifIdBefore,
  );

  // Jadwalkan notifikasi tepat waktu
  scheduleNotification(
    habitId: habit.id,
    habitTitle: habit.title,
    scheduledTime: scheduledDate,
    message: "Reminder: Saatnya ${habit.title}. Keep up the good habit!",
    notificationId: notifIdExact,
  );
}
