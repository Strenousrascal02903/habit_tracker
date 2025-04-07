import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/data/utils/String_utils.dart';
import '../../utils/detail_row.dart';
import 'detail_habit_controller.dart';
import 'package:intl/intl.dart';

class DetailHabitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DetailHabitController controller = Get.put(DetailHabitController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text("Detail Habit"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          int activeDay = controller.activeDay;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color(0xFF3c735c),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeSentence(controller.habit.value.title),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      DetailRow(
                        size: 14,
                        margin: 25,
                        label: "Jam Kegiatan",
                        value: controller.habit.value.time,
                        icon: Icons.access_time,
                      ),
                      DetailRow(
                        size: 14,
                        margin: 38,
                        label: "Target Hari",
                        value: "${controller.habit.value.targetDays} hari",
                        icon: Icons.calendar_today,
                      ),
                      DetailRow(
                        size: 14,
                        margin: 69,
                        label: "Durasi",
                        value:
                            "${controller.habit.value.durationMinutes} menit",
                        icon: Icons.timer,
                      ),
                      DetailRow(
                        size: 14,
                        margin: 68,
                        label: "Dibuat",
                        value: DateFormat("dd MMMM yyyy", "id_ID")
                            .format(controller.habit.value.createdAt),
                        icon: Icons.date_range,
                      ),
                      DetailRow(
                        size: 14,
                        margin: 8,
                        label: "Perkiraan Selesai",
                        value: DateFormat("dd MMMM yyyy", "id_ID")
                            .format(controller.predictionFinishedDate),
                        icon: Icons.event_available,
                      ),
                    ],
                  ),
                ),
              ), // Progress Bar
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: controller.habit.value.targetDays,
                  itemBuilder: (context, index) {
                    int dayIndex = index + 1;
                    // Gunakan key konsisten, misalnya "Day 1", "Day 2", dst.
                    String key = 'Day $dayIndex';
                    return Obx(() {
                      bool isCompleted = controller.tempProgress[key] ?? false;
                      bool isToday = (dayIndex == controller.activeDay);
                      bool isPast = (dayIndex < controller.activeDay);
                      bool isFuture = (dayIndex > controller.activeDay);

                      Color bgColor;
                      Color borderColor;
                      Color textColor;

                      if (isToday) {
                        if (isCompleted) {
                          bgColor = const Color(
                              0xFF3c735c); // Hari ini dan sudah centang → hijau penuh
                          borderColor = const Color(0xFF3c735c);
                          textColor = Colors.white;
                        } else {
                          bgColor = Colors
                              .white; // Hari ini dan belum centang → putih
                          borderColor =
                              const Color(0xFF9abda5); // border abu-abu
                          textColor = const Color(0xFF9abda5);
                        }
                      } else if (isPast) {
                        if (isCompleted) {
                          bgColor = const Color(0xFF3c735c).withOpacity(
                              0.5); // Hari lewat dan centang → hijau dengan opacity berkurang
                          borderColor =
                              const Color(0xFF3c735c).withOpacity(0.5);
                          textColor = Colors.white;
                        } else {
                          bgColor = Colors
                              .red; // Hari lewat dan belum centang → merah
                          borderColor = Colors.red;
                          textColor = Colors.white;
                        }
                      } else {
                        // isFuture
                        bgColor = Colors.white; // Hari mendatang → putih
                        borderColor = Colors.grey; // border abu-abu
                        textColor = Colors.grey;
                      }

                      return GestureDetector(
                        onTap: isToday
                            ? () => controller.toggleDayStatus(key, dayIndex)
                            : null,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border.all(color: borderColor, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Day $dayIndex',
                            style: TextStyle(
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              // Dua tombol: Simpan dan Hapus
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Simpan
                  // Tombol Hapus
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Konfirmasi",
                          middleText:
                              "Apakah Anda yakin ingin menghapus habit ini?",
                          textConfirm: "Ya",
                          textCancel: "Batal",
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                          onConfirm: () {
                            controller.deleteHabit(controller.habit.value.id);
                            Get.offAllNamed("/home"); // Tutup dialog
                          },
                        );
                      },
                      child: Text("Hapus"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape:
                            StadiumBorder(), // Ini membuat tombol bulat seperti default
                        side: BorderSide(
                            color: Colors.red), // Garis pinggir merah
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isChanged.value
                          ? controller.saveChanges
                          : null,
                      child: Text("Simpan"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isChanged.value
                            ? const Color(0xFF35633c)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
