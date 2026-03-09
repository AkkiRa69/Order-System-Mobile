import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LottieBuilder.asset(
                "assets/Lottie/Animation - 1716440045068.json"),
          ),
        ],
      ),
      nextScreen: const ControllerPage(),
      backgroundColor: AppColor.appBarColor,
      splashIconSize: MediaQuery.of(context).size.height,
      duration: 3000,
    );
  }
}
