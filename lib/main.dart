import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habit_tracker/data/api/firebase_api.dart';
import 'package:habit_tracker/data/routes/app_pages.dart';
import 'package:habit_tracker/data/routes/app_routes.dart';
import 'package:habit_tracker/data/service/exact_alarm.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi format tanggal (locale Indonesia)
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi GetStorage
  await GetStorage.init();

  // Inisialisasi TimeZone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

  // Cek apakah exact alarms diizinkan dan print hasilnya
  final canScheduleExact = await ExactAlarmPermission.canScheduleExactAlarms();
  print("Exact alarm permitted: $canScheduleExact");
  if (!canScheduleExact) {
    print("Exact alarm belum diizinkan, membuka pengaturan...");
    await ExactAlarmPermission.openExactAlarmSettings();
  }

  // Inisialisasi Flutter Local Notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Ambil habitId dari payload
      final habitId = response.payload;
      print("Notifikasi di-tap: $habitId");
      // Navigasi ke halaman detail dengan id habit
      if (habitId != null) {
        // Pastikan route '/detail' sudah didefinisikan di GetMaterialApp
        Get.toNamed('/detail_habit', arguments: habitId);
      }
    },
  );

  // Inisialisasi FirebaseApi (jika ada pengaturan khusus FCM)
  await FirebaseApi().initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Habit Tracker",
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
