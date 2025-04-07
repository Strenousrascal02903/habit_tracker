import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_habit_controller.dart';

class EditHabitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EditHabitController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Habit"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Habit
            TextField(
              maxLength: 100,
              controller: controller
                  .titleController, // Pakai controller yang sudah diinisialisasi
              style: TextStyle(color: Colors.black),
              cursorColor: const Color(0xFF3c735c),
              decoration: InputDecoration(
                labelText: "Nama Habit",
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onChanged: controller.setTitle,
            ),
            SizedBox(height: 20),
            // Target Hari (Slider + TextField)
            Text("Target Hari:"),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Slider(
                        activeColor: const Color(0xFF3c735c),
                        value: controller.targetDays.value.toDouble(),
                        min: 7,
                        max: 90,
                        divisions: 99,
                        onChanged: (value) =>
                            controller.setTargetDays(value.toInt()),
                      )),
                ),
                SizedBox(
                  width: 70,
                  child: Obx(() => TextField(
                        cursorColor: const Color(0xFF3c735c),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                            text: "${controller.targetDays.value}")
                          ..selection = TextSelection.fromPosition(TextPosition(
                              offset: "${controller.targetDays.value}".length)),
                        onSubmitted: (value) {
                          int newValue = int.tryParse(value) ?? 1;
                          controller.setTargetDays(newValue.clamp(1, 90));
                        },
                      )),
                ),
              ],
            ),
            // Durasi Habit (Slider + TextField)
            SizedBox(height: 20),
            Text("Durasi (menit):"),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Slider(
                        activeColor: const Color(0xFF3c735c),
                        value: controller.durationMinutes.value.toDouble(),
                        min: 5,
                        max: 60,
                        divisions: 11,
                        onChanged: (value) =>
                            controller.setDurationMinutes(value.toInt()),
                      )),
                ),
                SizedBox(
                  width: 70,
                  child: Obx(() => TextField(
                        cursorColor: const Color(0xFF3c735c),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                            text: "${controller.durationMinutes.value}")
                          ..selection = TextSelection.fromPosition(TextPosition(
                              offset: "${controller.durationMinutes.value}"
                                  .length)),
                        onSubmitted: (value) {
                          int newValue = int.tryParse(value) ?? 5;
                          controller.setDurationMinutes(newValue.clamp(5, 120));
                        },
                      )),
                ),
              ],
            ),
            // Pilih Jam Mulai Habit
            SizedBox(height: 20),
            Text("Jam Mulai:"),
            Obx(() => GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: controller.startTime.value,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: const Color(0xFF3c735c),
                            hintColor: const Color(0xFF3c735c),
                            colorScheme: ColorScheme.light(
                                primary: const Color(0xFF3c735c)),
                            buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      controller.setStartTime(pickedTime);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF3c735c)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.startTime.value.format(context),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )),
            Spacer(),
            ElevatedButton(
              onPressed: controller.saveHabit,
              child: Text("Simpan"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35633c),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
