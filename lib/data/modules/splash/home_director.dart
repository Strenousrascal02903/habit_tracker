import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi TimeZone
  tz.initializeTimeZones();
  final tz.Location myLocation = tz.getLocation('Asia/Jakarta');
  tz.setLocalLocation(myLocation);
  print("Current Timezone: ${myLocation.name}");

  // Inisialisasi pengaturan notifikasi untuk Android dan iOS
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'app_icon'); // Pastikan 'app_icon' tersedia di drawable

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Callback ketika notifikasi di-tap
      print("Notifikasi di-tap: ${response.payload}");
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notification Demo",
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // Fungsi untuk menampilkan notifikasi langsung
  Future<void> _showHelloWorldNotification() async {
    // Buat detail notifikasi untuk Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'hello_channel_id', // ID channel
      'Hello Notifications', // Nama channel
      channelDescription: 'Channel untuk hello notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    // Detail notifikasi untuk iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    // Gabungkan detail notifikasi
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Tampilkan notifikasi secara langsung
    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi
      "Hello", // Judul notifikasi
      "Hello World", // Isi pesan
      notificationDetails,
      payload: 'Hello World',
    );
  }

  // Fungsi untuk menjadwalkan notifikasi yang muncul 20 detik dari sekarang menggunakan zonedSchedule
  Future<void> _scheduleHelloWorldNotification() async {
    // Buat detail notifikasi untuk Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'schedule_channel_id', // ID channel untuk scheduled notifications
      'Scheduled Notifications', // Nama channel
      channelDescription: 'Channel untuk scheduled notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    // Detail notifikasi untuk iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    // Gabungkan detail notifikasi
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Tentukan waktu jadwal notifikasi (20 detik dari sekarang)
    final scheduledTime = DateTime.now().add(const Duration(seconds: 20));
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Jadwalkan notifikasi menggunakan zonedSchedule
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // ID notifikasi berbeda
      "Scheduled Hello", // Judul notifikasi
      "Hello World from scheduled notification", // Isi pesan
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'Scheduled Hello World',
    );

    print("Notifikasi terjadwal pada: $scheduledTime");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _showHelloWorldNotification,
          icon: const Icon(Icons.notifications),
        ),
        title: const Text("Notification Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Tekan ikon notifikasi di kiri atas untuk notifikasi langsung."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleHelloWorldNotification,
              child: const Text("Jadwalkan Notifikasi (20 detik)"),
            ),
          ],
        ),
      ),
    );
  }
}
