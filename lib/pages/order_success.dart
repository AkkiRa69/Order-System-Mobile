// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/oder_success.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:page_transition/page_transition.dart';

class OrderSuccessPage extends StatelessWidget {
  final String appBarTitle, title, subtitle, btnText;
  final void Function(BuildContext)? onPressed;
  const OrderSuccessPage(
      {super.key,
      required this.btnText,
      required this.onPressed,
      required this.appBarTitle,
      required this.subtitle,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        centerTitle: true,
        title: Text(appBarTitle),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: ControllerPage(),
                      type: PageTransitionType.leftToRight));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OrderSuccess(
            subTitle: subtitle,
            title: title,
          ), // Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              children: [
                Expanded(
                  child: LinearButton(
                    text: btnText,
                   onPressed: () => onPressed!(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
