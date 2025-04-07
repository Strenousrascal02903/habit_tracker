import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/databases/db_helper.dart';
import 'package:habit_tracker/data/models/habit_model.dart';
import 'package:habit_tracker/data/modules/home/home_controller.dart';

class EditHabitController extends GetxController {
  // Buat TextEditingController untuk field nama habit
  late TextEditingController titleController;

  var title = ''.obs;
  var targetDays = 30.obs;
  var startTime = TimeOfDay.now().obs;
  var durationMinutes = 30.obs;

  final DBHelper _dbHelper = DBHelper(); // Inisialisasi DB

  // Habit yang akan diedit
  late HabitModel habitToEdit;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is HabitModel) {
      habitToEdit = Get.arguments;
      // Set nilai awal dari habit yang akan diedit
      title.value = habitToEdit.title;
      targetDays.value = habitToEdit.targetDays;
      durationMinutes.value = habitToEdit.durationMinutes;
      // Konversi waktu (format "HH:mm") menjadi TimeOfDay
      List<String> parts = habitToEdit.time.split(':');
      if (parts.length == 2) {
        int hour = int.tryParse(parts[0]) ?? 0;
        int minute = int.tryParse(parts[1]) ?? 0;
        startTime.value = TimeOfDay(hour: hour, minute: minute);
      }
      // Inisialisasi titleController dengan nilai awal
      titleController = TextEditingController(text: habitToEdit.title);
    } else {
      // Jika tidak ada habit yang diterima, inisialisasi controller kosong
      titleController = TextEditingController();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void setTitle(String value) => title.value = value;
  void setTargetDays(int value) => targetDays.value = value;
  void setDurationMinutes(int value) => durationMinutes.value = value;
  void setStartTime(TimeOfDay value) => startTime.value = value;

  Future<void> pickStartTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime.value,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF3c735c),
            hintColor: const Color(0xFF3c735c),
            colorScheme: ColorScheme.light(primary: const Color(0xFF3c735c)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
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

    // Perbarui habitToEdit dengan nilai baru
    habitToEdit.title = title.value;
    habitToEdit.targetDays = targetDays.value;
    habitToEdit.durationMinutes = durationMinutes.value;
    habitToEdit.time =
        "${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}";
    // Jika perlu, update progressValue (atau tetap pertahankan progress lama)
    habitToEdit.progressValue = 0.0; // atau hitung ulang jika diperlukan

    // Lakukan update ke database
    await _dbHelper.updateHabit(habitToEdit);

    // Refresh data di HomeController
    Get.find<HomeController>().fetchHabits();

    Get.back(); // Kembali ke halaman sebelumnya
  }
}
