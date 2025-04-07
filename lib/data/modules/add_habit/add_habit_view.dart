import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_habit_controller.dart';

class AddHabitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddHabitController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tambah Habit"),
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
              style: TextStyle(color: Colors.black), // Text input tetap hitam  
              cursorColor: const Color(0xFF3c735c), // Cursor berwarna biru
              decoration: InputDecoration(
                labelText: "Nama Habit",
                labelStyle:
                    TextStyle(color: Colors.black), // Label berwarna biru
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Border aktif berwarna biru
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Border normal berwarna biru
                ),
              ),
              onChanged: controller.setTitle,
            ),
            SizedBox(height: 10),

            // Target Hari (Slider + TextField)
            Text("Target Hari:"),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Slider(
                        activeColor: const Color(0xFF3c735c),
                        value: controller.targetDays.value.toDouble(),
                        min: 1,
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
            SizedBox(height: 10),
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
                          controller.setDurationMinutes(newValue.clamp(5, 60));
                        },
                      )),
                ),
              ],
            ),

            // Pilih Jam Mulai Habit
            SizedBox(height: 10),
            Text("Jam Mulai:"),
            Obx(() => GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: controller.startTime.value,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: const Color(
                                0xFF3c735c), // 🔵 Warna utama (AppBar & tombol OK)
                            hintColor:
                                const Color(0xFF3c735c), // 🔵 Warna indikator
                            colorScheme: ColorScheme.light(
                                primary: const Color(
                                    0xFF3c735c)), // 🔵 Warna highlight
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
