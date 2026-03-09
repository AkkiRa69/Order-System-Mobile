// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/my_pass_text_field.dart';
import 'package:grocery_store/components/my_text_field.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F9),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: LinearButton(text: "Save settings", onPressed: () {}),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(0xFFFFFFFF),
      title: Text("About Me"),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Personal Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ), //Text field
                MyTextField(
                  hintText: "San Monyakkhara",
                  icon: CupertinoIcons.person,
                  controller: null,
                ),
                MyTextField(
                  hintText: "sanmonyakkhara@gmail.com",
                  icon: Icons.email_outlined,
                  controller: null,
                ),
                MyTextField(
                  hintText: "+855 093 822 805",
                  icon: CupertinoIcons.phone,
                  controller: null,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Change Password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ), //Text field
                MyTextField(
                  hintText: "Current password",
                  icon: CupertinoIcons.lock,
                  controller: null,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: MyPassTextField(
                      hintText: "New password",
                      preIcon: CupertinoIcons.lock,
                      suffIcon: Icons.visibility_outlined),
                ),
                MyTextField(
                  hintText: "Confirm password",
                  icon: CupertinoIcons.lock,
                  controller: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
