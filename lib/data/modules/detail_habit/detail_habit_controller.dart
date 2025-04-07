import 'package:get/get.dart';
import 'package:habit_tracker/data/databases/db_helper.dart';
import '../../models/habit_model.dart';
import 'package:flutter/material.dart';
import '../../utils/schedule.dart'; // Pastikan path-nya sesuai
import '../home/home_controller.dart';

class DetailHabitController extends GetxController {
  final DBHelper dbHelper = DBHelper();
  var habit = HabitModel(
    id: '',
    title: '',
    time: '',
    targetDays: 0,
    durationMinutes: 0,
    progress: {},
    progressValue: 0.0,
    createdAt: DateTime.now(),
  ).obs;

  var tempProgress = <String, bool>{}.obs;
  var isChanged = false.obs;

  final DBHelper _dbHelper = DBHelper();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is HabitModel) {
        // Jika argument sudah berupa HabitModel, langsung gunakan
        habit.value = Get.arguments;
        tempProgress.value = Map<String, bool>.from(habit.value.progress);
      } else if (Get.arguments is String) {
        // Jika argument hanya habitId (String), ambil habit dari DB
        final String habitId = Get.arguments;
        fetchHabitDetail(habitId);
      }
    }
  }

  Future<void> fetchHabitDetail(String habitId) async {
    HabitModel fetchedHabit = await dbHelper.getHabitById(habitId);
    if (fetchedHabit != null) {
      habit.value = fetchedHabit;
      tempProgress.value = Map<String, bool>.from(fetchedHabit.progress);
    }
  }

  int get activeDay {
    final now = DateTime.now();
    final created = habit.value.createdAt;
    final today = DateTime(now.year, now.month, now.day);
    final createdDate = DateTime(created.year, created.month, created.day);
    int diffDays = today.difference(createdDate).inDays;
    int active = diffDays + 1;
    if (active < 1) active = 1;
    if (active > habit.value.targetDays) active = habit.value.targetDays;
    return active;
  }

  void toggleDayStatus(String key, int dayIndex) {
    if (dayIndex != activeDay) return;
    if (tempProgress[key] == true) return;

    Get.defaultDialog(
      title: "Konfirmasi",
      middleText:
          "Apakah kamu yakin sudah menyelesaikan habit hari ini? Status tidak bisa diubah setelah konfirmasi.",
      textConfirm: "Ya",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF35633c),
      onConfirm: () {
        tempProgress[key] = true;
        tempProgress.refresh();
        isChanged.value = true;
        Get.back();
      },
    );
  }

  Future<void> deleteHabit(String id) async {
    // Hapus habit dari database
    await dbHelper.deleteHabit(id);
    print("Habit with id: $id deleted from database");

    // Gunakan fungsi generateNotificationId dengan suffix yang sama
    int notifIdBefore = generateNotificationId(id + "_before");
    int notifIdExact = generateNotificationId(id + "_exact");

    print("Deleting habit with id: $id");
    print(
        "Cancelling notifications with IDs: $notifIdBefore and $notifIdExact");
    await cancelHabitNotification(notifIdBefore);
    await cancelHabitNotification(notifIdExact);
  }

  Future<void> saveChanges() async {
    habit.update((val) {
      if (val != null) {
        val.progress = Map<String, bool>.from(tempProgress);
        val.progressValue = _calculateProgress(val.progress);
      }
    });
    habit.refresh();
    await _dbHelper.updateHabit(habit.value);
    Get.find<HomeController>().fetchHabits();
    isChanged.value = false;
    Get.back(result: true);
  }

  double _calculateProgress(Map<String, bool> progress) {
    int active = activeDay;
    int completed = 0;
    for (int i = 1; i <= active; i++) {
      if (progress["Day $i"] ?? false) {
        completed++;
      }
    }
    return completed / habit.value.targetDays;
  }

  DateTime get predictionFinishedDate {
    return habit.value.createdAt.add(Duration(days: habit.value.targetDays));
  }
}
