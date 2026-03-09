import 'dart:async'; // Import async library for Timer

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/pages/forgot_password_pages/OTP_Screen_page.dart';
import 'package:page_transition/page_transition.dart';

class VerifyNumberPage extends StatefulWidget {
  const VerifyNumberPage({
    super.key,
  });

  @override
  State<VerifyNumberPage> createState() => _VerifyNumberPageState();
}

class _VerifyNumberPageState extends State<VerifyNumberPage> {
  int secondRemaining = 90; // Move the countdown variable here

  @override
  void initState() {
    super.initState();
    startCountdown(); // Start the countdown when the page initializes
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondRemaining > 0) {
          secondRemaining--;
        } else {
          timer.cancel(); // Cancel the timer when countdown reaches 0
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        "Verify Number",
      ),
    );
  }

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
              "Lorem ipsum dolor sit amet, consetetursadipscing elitr, sed diam nonumy",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff868889),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/flag.png",
                  height: 18,
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "+855",
                    style: TextStyle(
                        color: Colors.black), // Ensure text color is black
                  ),
                ),
                // const Spacer(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff868889),
                ),
                const SizedBox(
                  height: 45,
                  child: VerticalDivider(
                    color: Color(0xffC4C4C4),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Allow only digits
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your number",
                      hintStyle: TextStyle(color: Color(0xff868889)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: LinearButton(
                    text: "Next",
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child:  OTPScreenPage(),
                              type: PageTransitionType.fade));
                    },
                  ),
                ),
              ],
            ),
          ),
          Text("Resend confirmation code (${_formatTime(secondRemaining)})"),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
