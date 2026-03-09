import 'package:flutter/material.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/notification_tile.dart';
import 'package:grocery_store/constant/appcolor.dart';

// ignore: must_be_immutable
class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.appBarColor,
      title: const Text("Notifications"),
      centerTitle: true,
    );
  }

  List title = [
    [
      "Allow Notifications",
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumym"
    ],
    [
      "Email Notifications",
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumym"
    ],
    [
      "Order Notifications",
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumym"
    ],
    [
      "General Notifications",
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumym"
    ],
  ];

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: title.length,
            itemBuilder: (context, index) {
              return NotificationTile(
                  title: title[index][0], subTitle: title[index][1]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      child: LinearButton(text: "Save settings", onPressed: () {}),
    );
  }
}
