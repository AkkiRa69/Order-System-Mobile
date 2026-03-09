// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_bar.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/pages/login_page.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  void backToLoginPage(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: LoginPage(), type: PageTransitionType.leftToRight));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppBar(() {
        backToLoginPage(context);
      }),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Image.asset(
              "assets/images/cover3.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.55,
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
                    "Create account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Quickly create your account",
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
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              hintText: "Phone number",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(bottom: 15),
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
                        //login button
                        Row(
                          children: [
                            Expanded(
                              child: LinearButton(
                                text: "Signup",
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: ControllerPage(),
                                          type:
                                              PageTransitionType.leftToRight));
                                },
                              ),
                            ),
                          ],
                        )
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
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            backToLoginPage(context);
                          },
                          child: Text(
                            "Login",
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
