import 'dart:convert';

class HabitModel {
  String id;
  String title;
  String time;
  int targetDays;
  int durationMinutes;
  Map<String, bool> progress;
  double progressValue;
  DateTime createdAt;

  HabitModel({
    required this.id,
    required this.title,
    required this.time,
    required this.targetDays,
    required this.durationMinutes,
    Map<String, bool>? progress,
    this.progressValue = 0.0,
    required this.createdAt,
  }) : progress = progress ?? {}; // Jika progress null, buat map kosong

  // Factory method untuk convert dari JSON
  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
        id: json['id'],
        title: json['title'],
        time: json['time'],
        targetDays: json['targetDays'],
        durationMinutes: json['durationMinutes'],
        progress: json['progress'] != null
            ? _parseProgress(json['progress']) // 🔥 Fix FormatException
            : {},
        progressValue: (json['progressValue'] ?? 0.0).toDouble(),
        createdAt: DateTime.parse(json['createdAt']),
      );

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time': time,
        'targetDays': targetDays,
        'durationMinutes': durationMinutes,
        'progress':
            jsonEncode(progress), // 🔥 Simpan dalam format JSON yang valid
        'progressValue': progressValue,
        'createdAt': createdAt.toIso8601String(),
      };

  // 🔥 Fungsi untuk parsing progress dengan aman
  static Map<String, bool> _parseProgress(dynamic progressData) {
    if (progressData is String) {
      try {
        return Map<String, bool>.from(jsonDecode(progressData));
      } catch (e) {
        print("Error decoding progress: $e");
        return {};
      }
    } else if (progressData is Map) {
      return Map<String, bool>.from(progressData);
    }
    return {};
  }
}
