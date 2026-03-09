import 'package:flutter/material.dart';

class AddressTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  const AddressTextField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: Color(0xff868889),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xff868889),
          ),
        ),
      ),
    );
  }
}
