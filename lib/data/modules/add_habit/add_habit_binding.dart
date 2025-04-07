import 'package:get/get.dart';
import 'add_habit_controller.dart';

class AddHabitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddHabitController>(() => AddHabitController());
  }
}
