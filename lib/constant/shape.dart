import 'package:flutter/material.dart';

Widget circleShape() {
  return Container(
    width: 52,
    height: 52,
    decoration: const BoxDecoration(
      color: Color(0xff6cc51d),
      shape: BoxShape.circle,
    ),
  );
}

Widget squreShape() {
  return Container(
    width: 53,
    height: 58,
    decoration: BoxDecoration(
      color: const Color(0xff6cc51d),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Icon(
      Icons.more_vert_rounded,
      color: Colors.white,
      size: 20,
    ),
  );
}
