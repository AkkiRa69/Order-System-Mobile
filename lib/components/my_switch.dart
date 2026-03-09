import 'package:flutter/material.dart';
import 'package:grocery_store/constant/appcolor.dart';

// ignore: must_be_immutable
class MySwitch extends StatelessWidget {
  bool isSwitch;
  void Function(bool)? onChanged;
  MySwitch({super.key, required this.isSwitch, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.7,
      child: Switch(
        value: isSwitch,
        activeColor: const Color(0xffffffff),
        activeTrackColor: const Color(0xff6CC51D),
        inactiveTrackColor: AppColor.appBarColor,
        inactiveThumbColor: const Color(0xff6CC51D),
        onChanged: (value) => onChanged!(value),
      ),
    );
  }
}
