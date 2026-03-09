// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_bar.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/my_switch.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/pages/forgot_password_pages/password_recovery_page.dart';
import 'package:grocery_store/pages/home_page.dart';
import 'package:grocery_store/pages/signup_page.dart';
import 'package:grocery_store/pages/welcome_page.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void backToWelcomePage(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: WelcomePage(), type: PageTransitionType.leftToRight));
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }

  bool isSwitch = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        () {
          backToWelcomePage(context);
        },
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Image.asset(
              "assets/images/cover2.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 25),
              decoration: BoxDecoration(
                color: Color(0xFFF4F5F9),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in to your account",
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      children: [
                        //email text field
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              hintText: "Email address",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        //password text field
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixIcon: Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        //remember me
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                MySwitch(
                                    isSwitch: isSwitch,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitch = value;
                                      });
                                    }),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Remember me",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: PasswordRecoveryPage(),
                                        type: PageTransitionType.fade));
                              },
                              style: TextButton.styleFrom(
                                elevation: 0,
                              ),
                              child: Text(
                                "Forgot password",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF407EC7),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //login button
                        Row(
                          children: [
                            Expanded(
                                child: LinearButton(
                                    text: "Login",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: ControllerPage(),
                                              type: PageTransitionType
                                                  .leftToRight));
                                    })),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //sign up text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SignUpPage(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
