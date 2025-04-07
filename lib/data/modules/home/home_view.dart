import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/data/utils/String_utils.dart';
import '../../utils/detail_row.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    // Daftar warna untuk card, yang akan berganti-ganti berdasarkan index
    final List<Color> cardColors = [
      const Color(0xFF35633c), // Warna 1
      const Color(0xFF3c735c), // Warna 2
    ];
    final List<Color> lineColors = [
      const Color(0xFF9abda5), // Warna 3
      const Color(0xFF35633c), // Warna 1
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          "Habit Tracker",
          style: TextStyle(color: const Color(0xFF021c0f)),
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() {
              int completed = controller.completedHabitsToday;
              int total = controller.habits.length;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: const Color(0xFF3c735c)),
                  SizedBox(width: 4),
                  Text(
                    "$completed/$total",
                    style: TextStyle(
                      color: const Color(0xFF3c735c),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      body: Obx(() => RefreshIndicator(
            backgroundColor: Colors.white,
            color: const Color(0xFF3c735c),
            onRefresh: () async {
              controller.fetchHabits();
            },
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: controller.habits.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                var habit = controller.habits[index];
                // Pilih warna card berdasarkan index
                Color cardColor = cardColors[index % cardColors.length];
                Color lineColor = lineColors[index % lineColors.length];

                // Hitung progress per habit
                double progressPercentage =
                    (habit.progress.values.where((done) => done).length /
                            habit.targetDays) *
                        100;
                return GestureDetector(
                  onTap: () => Get.toNamed('/detail_habit', arguments: habit)
                      ?.then((result) {
                    if (result == true) {
                      controller.fetchHabits();
                    }
                  }),
                  child: Card(
                    color: cardColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row untuk title dan tombol edit
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 90,
                                child: Text(
                                  capitalizeSentence(habit.title),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Navigasi ke halaman edit habit (jika ada) atau panggil fungsi edit
                                  Get.toNamed('/edit_habit', arguments: habit)
                                      ?.then((result) {
                                    if (result == true) {
                                      controller.fetchHabits();
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          DetailRow(
                            size: 12,
                            margin: 16.5,
                            label: "Jam",
                            value: habit.time,
                          ),
                          DetailRow(
                            size: 12,
                            margin: 3,
                            label: "Target",
                            value: "${habit.targetDays} hari",
                          ),
                          DetailRow(
                            size: 12,
                            margin: 5.8,
                            label: "Durasi",
                            value: "${habit.durationMinutes} menit",
                          ),

// ...

                          Spacer(),
                          LinearProgressIndicator(
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(12),
                            value: progressPercentage / 100,
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(lineColor),
                          ),
                          SizedBox(height: 8),
                          // Tampilkan persentase progress dan indikator tugas selesai/target
                          Row(
                            children: [
                              Text(
                                "${progressPercentage.toStringAsFixed(1)}%",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "${habit.progress.values.where((done) => done).length}/${habit.targetDays}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF35633c),
        child: Icon(Icons.add),
        onPressed: () => Get.toNamed('/add_habit')?.then((_) {
          controller.fetchHabits();
        }),
      ),
    );
  }
}
