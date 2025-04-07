import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get.dart';
import '../home/home_view.dart'; // pastikan HomeView sudah ada

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splash: Center(
        child: Text(
          "Habit Tracker", 
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      nextScreen: HomeRedirector(), // Menggunakan widget redirect
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color(0xFF3c735c),
    );
  }
}

class HomeRedirector extends StatefulWidget {
  @override
  _HomeRedirectorState createState() => _HomeRedirectorState();
}

class _HomeRedirectorState extends State<HomeRedirector> {
  @override
  void initState() {
    super.initState();
    // Pindah ke route '/home' secara langsung
    Future.microtask(() => Get.offNamed('/home'));
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan sesuatu yang sederhana (bisa kosong) sementara proses pindah berlangsung
    return Container();
  }
}
