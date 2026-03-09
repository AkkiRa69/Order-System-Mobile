// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_bar.dart';
import 'package:grocery_store/pages/login_page.dart';
import 'package:page_transition/page_transition.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        () {},
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            child: Image.asset(
              "assets/images/cover1.png",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 25),
              decoration: BoxDecoration(
                color: Color(0xFFF4F5F9),
                // color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy",
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  //button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Column(
                      children: [
                        //continue with google button
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(18),
                              // backgroundColor: Colors.transparent,
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "assets/icons/google.png",
                                  height: 20,
                                ),
                                // Spacer(),

                                Text(
                                  "Continue with google",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //create an account button
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                // Colors.white,
                                Color.fromARGB(255, 190, 249, 192),
                                Color.fromARGB(255, 136, 241, 140),
                                const Color.fromARGB(255, 95, 236, 100),
                              ],
                            ),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(18),
                              // backgroundColor: Colors.transparent,
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  "assets/icons/profile.png",
                                  height: 20,
                                ),
                                // Spacer(),

                                Text(
                                  "Create an account",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //login text
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
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: LoginPage(),
                                    type: PageTransitionType.rightToLeft));
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
