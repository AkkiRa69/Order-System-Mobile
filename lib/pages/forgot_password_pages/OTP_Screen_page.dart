import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/pages/login_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class OTPScreenPage extends StatefulWidget {
  const OTPScreenPage({Key? key}) : super(key: key);

  @override
  State<OTPScreenPage> createState() => _OTPScreenPageState();
}

class _OTPScreenPageState extends State<OTPScreenPage> {
  late int randomNumber6digit;

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
    showRandomNumberSnackbar();
  }

  void generateRandomNumber() {
    // Generate a random 6-digit number
    var random = Random();
    randomNumber6digit = random.nextInt(900000) +
        100000; // Generate a random number between 100000 and 999999
  }

  void showRandomNumberSnackbar() {
    // Display the generated random number
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "Verification Code",
        "$randomNumber6digit is your Big-Cart verification code.",
        duration: const Duration(seconds: 5),
      );
    });
  }

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Verify Number",
        ),
      ),
      body: _buildBody(context),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      color: Colors.black,
      fontSize: 22,
    ),
    decoration: BoxDecoration(
      color: AppColor.appBarColor,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Verify your number",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              bottom: 25,
              top: 15,
            ),
            child: Text(
              "Enter your OTP code below",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff868889),
              ),
            ),
          ),
          Pinput(
            keyboardType: TextInputType.number,
            length: 6,
            controller: _otpController,
            animationDuration: const Duration(milliseconds: 200),
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(
                color: Colors.green,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: LinearButton(
                    text: "Next",
                    onPressed: () {
                      if (_otpController.text ==
                          randomNumber6digit.toString()) {
                        // If entered OTP matches the generated number, navigate to LoginPage
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const LoginPage(),
                            type: PageTransitionType.fade,
                          ),
                        );
                      } else {
                        // If entered OTP does not match the generated number, show an error message or handle it accordingly
                        // For example, show a snackbar with an error message
                        Get.snackbar("Error Message",
                            "You entered the Incorrect verification code.");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Didn't receive the code?",
            style: TextStyle(color: Color(0xff868889), fontSize: 16),
          ),
          GestureDetector(
            onTap: () {
              generateRandomNumber();
              showRandomNumberSnackbar();
            },
            child: const Text(
              "Resend a new code",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
