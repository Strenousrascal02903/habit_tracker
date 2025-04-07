// lib/modules/splash/splash_controller.dart
import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Tunda selama 3 detik, lalu navigasi ke halaman Home
    // Timer(Duration(seconds: 2), () {
    //   Get.offNamed('/home'); // Ganti '/home' sesuai route yang kamu inginkan
    // });
  }
}
