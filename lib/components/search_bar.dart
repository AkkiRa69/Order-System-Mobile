import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final void Function()? searchTap;
  final void Function()? onTap;
  const MySearchBar({Key? key, required this.onTap, required this.searchTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.symmetric(horizontal: 17),
        child: TextFormField(
          onTap: searchTap,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            prefixIcon: Image.asset(
              "assets/icons/search.png",
              color: const Color(0xFF868889),
            ),
            hintText: "Search keywords...",
            suffixIcon: IconButton(
              onPressed: onTap,
              icon: Image.asset(
                "assets/icons/filter.png",
                color: const Color(0xFF868889),
              ),
            ),
            hintStyle: const TextStyle(color: Color(0xFF868889)),
            border: InputBorder.none,
          ),
        ));
  }
}
