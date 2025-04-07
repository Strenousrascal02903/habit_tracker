import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/databases/db_helper.dart';
import 'package:uuid/uuid.dart';
import '../../models/habit_model.dart';

import '../home/home_controller.dart';

class AddHabitController extends GetxController {
  var title = ''.obs;
  var targetDays = 30.obs;
  var startTime = TimeOfDay.now().obs;
  var durationMinutes = 30.obs;

  final DBHelper _dbHelper = DBHelper(); // Inisialisasi DB

  void setTitle(String value) => title.value = value;
  void setTargetDays(int value) => targetDays.value = value;
  void setDurationMinutes(int value) => durationMinutes.value = value;
  void setStartTime(TimeOfDay value) => startTime.value = value;

  Future<void> pickStartTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime.value,
    );
    if (pickedTime != null) {
      setStartTime(pickedTime);
    }
  }

  Future<void> saveHabit() async {
    if (title.value.isEmpty) {
      Get.snackbar("Error", "Judul tidak boleh kosong!");
      return;
    }

    // Inisialisasi progress untuk semua hari
    Map<String, bool> progress = {};
    for (int i = 1; i <= targetDays.value; i++) {
      progress["Day $i"] = false;
    }

    var newHabit = HabitModel(
      id: Uuid().v4(),
      title: title.value,
      time:
          "${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}",
      targetDays: targetDays.value,
      durationMinutes: durationMinutes.value,
      progress: progress,
      progressValue: 0.0,
      createdAt: DateTime.now(),
    );

    // Simpan ke database
    await _dbHelper.insertHabit(newHabit);

    // Update HomeController
    Get.find<HomeController>().fetchHabits();

    Get.back(); // Kembali ke halaman sebelumnya
  }
}
