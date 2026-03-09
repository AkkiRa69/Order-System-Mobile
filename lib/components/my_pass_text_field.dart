import 'package:flutter/material.dart';

class MyPassTextField extends StatelessWidget {
  final String hintText;
  final IconData preIcon, suffIcon;
  const MyPassTextField(
      {super.key,
      required this.hintText,
      required this.preIcon,
      required this.suffIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(5),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            preIcon,
            color: Colors.grey,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: Icon(
            suffIcon,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
