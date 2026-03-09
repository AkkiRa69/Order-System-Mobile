// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_import

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBottomNavBar extends StatefulWidget {
  final int index;
  final Function(int) onTap;
  MyBottomNavBar({required this.index, required this.onTap});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      onTap: (value) {
        widget.onTap(value);
      },
      height: 70,
      buttonBackgroundColor: Color(0xff6CC51D),
      items: [
        Icon(
          Icons.home_filled,
          color: widget.index == 0 ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.person,
          color: widget.index == 1 ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.favorite,
          color: widget.index == 2 ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.shopping_bag_outlined,
          color: widget.index == 3 ? Colors.white : Colors.black,
        ),
      ],
    );
  }
}
