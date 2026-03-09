import 'package:flutter/material.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/my_text_field.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/pages/forgot_password_pages/verify_number_page.dart';
import 'package:page_transition/page_transition.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Password Recovery",
        ),
      ),
      body: _buildBody(context),
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
            "Forgot Password",
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
          const MyTextField(
            hintText: "Email Address",
            icon: Icons.email_outlined,
            controller: null,
          ),
          const SizedBox(
            height: 5,
          ),
          const MyTextField(
            hintText: "New Password",
            icon: Icons.lock_open,
            controller: null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: LinearButton(
                    text: "Send link",
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const VerifyNumberPage(),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
