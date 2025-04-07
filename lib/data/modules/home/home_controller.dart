import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/data/databases/db_helper.dart';
import 'package:habit_tracker/data/service/notification_service.dart';

class HomeController extends GetxController {
  final DBHelper _dbHelper = DBHelper();
  var habits = <HabitModel>[].obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchHabits();
  }

  void fetchHabits() async {
    var data = await _dbHelper.getHabits();
    habits.assignAll(data);

    // Casting eksplisit untuk menghindari error tipe data
    Map<String, String> scheduledHabitTimes =
        (_storage.read('scheduledHabitTimes') as Map?)
                ?.cast<String, String>() ??
            {};

    for (var habit in habits) {
      if (!scheduledHabitTimes.containsKey(habit.id) ||
          scheduledHabitTimes[habit.id] != habit.time) {
        scheduleHabitReminders(habit);
        scheduledHabitTimes[habit.id] = habit.time;
      }
    }

    _storage.write('scheduledHabitTimes', scheduledHabitTimes);
  }

  // Fungsi untuk menghitung active day tiap habit
  int getActiveDay(HabitModel habit) {
    int diff = DateTime.now().difference(habit.createdAt).inDays;
    int active = diff + 1;
    if (active < 1) active = 1;
    if (active > habit.targetDays) active = habit.targetDays;
    return active;
  }

  // Getter untuk menghitung jumlah habit yang selesai di hari aktifnya
  int get completedHabitsToday {
    int count = 0;
    for (var habit in habits) {
      int active = getActiveDay(habit);
      if (habit.progress["Day $active"] == true) {
        count++;
      }
    }
    return count;
  }
}
