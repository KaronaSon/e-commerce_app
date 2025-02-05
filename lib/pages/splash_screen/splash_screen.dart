import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:ecommerc_app/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      backgroundColor: Colors.white,
      childWidget: SizedBox(
        child: Image.asset(
          "assets/icons/shopping.jpg",
          fit: BoxFit.cover,
          width: 400,
        ),
      ),
      duration: const Duration(milliseconds: 2000),
      animationDuration: const Duration(milliseconds: 2000),
      nextScreen: MainScreen(),
    );
  }
}
