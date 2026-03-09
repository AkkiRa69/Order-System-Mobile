import 'package:flutter/material.dart';
import 'package:grocery_store/constant/appcolor.dart';

class FilterTextField extends StatelessWidget {
  final String hintText;
  const FilterTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bodyColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(hintText),
          labelStyle: const TextStyle(
            color: Color(0xff868889),
          ),
        ),
      ),
    );
  }
}
