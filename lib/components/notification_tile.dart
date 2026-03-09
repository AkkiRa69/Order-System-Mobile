import 'package:flutter/material.dart';
import 'package:grocery_store/components/my_switch.dart';
import 'package:grocery_store/constant/appcolor.dart';

class NotificationTile extends StatefulWidget {
  final String title, subTitle;
  const NotificationTile(
      {super.key, required this.title, required this.subTitle});

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool isSwitch = false;

  void switching(bool value) {
    setState(() {
      isSwitch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.appBarColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(17),
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  widget.subTitle,
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xff868889)),
                ),
              ),
            ],
          ),
          MySwitch(isSwitch: isSwitch, onChanged: (value) => switching(value))
        ],
      ),
    );
  }
}
