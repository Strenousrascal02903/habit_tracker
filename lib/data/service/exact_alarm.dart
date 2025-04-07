import 'package:flutter/services.dart';

class ExactAlarmPermission {
  // Tentukan nama channel (bebas, tapi harus konsisten di Android)
  static const _channel = MethodChannel('com.example.exact_alarm_channel');

  /// Mengecek apakah aplikasi diizinkan menggunakan exact alarms
  static Future<bool> canScheduleExactAlarms() async {
    final bool canSchedule = await _channel.invokeMethod('canScheduleExactAlarms');
    return canSchedule;
  }

  /// Membuka pengaturan untuk mengaktifkan exact alarms
  static Future<void> openExactAlarmSettings() async {
    await _channel.invokeMethod('openExactAlarmSettings');
  }
}
