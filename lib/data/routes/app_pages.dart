import 'package:get/get.dart';
import 'package:habit_tracker/data/modules/detail_habit/detail_habit_binding.dart';
import 'package:habit_tracker/data/modules/detail_habit/detail_habit_view.dart';
import 'package:habit_tracker/data/modules/edit_habit/edit_habit_binding.dart';
import 'package:habit_tracker/data/modules/edit_habit/edit_habit_view.dart';
import 'package:habit_tracker/data/modules/splash/splash_binding.dart';
import 'package:habit_tracker/data/modules/splash/splash_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/add_habit/add_habit_binding.dart';
import '../modules/add_habit/add_habit_view.dart';
// import '../modules/detail_habit/detail_habit_binding.dart';
// import '../modules/detail_habit/detail_habit_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ADD_HABIT,
      page: () => AddHabitView(),
      binding: AddHabitBinding(),
    ),
    GetPage(
      name: Routes.EDIT_HABIT,
      page: () => EditHabitView(),
      binding: EditHabitBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_HABIT,
      page: () => DetailHabitView(),
      binding: DetailHabitBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
