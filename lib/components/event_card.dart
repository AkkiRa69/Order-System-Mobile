import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title, subTitle;
  final bool isPast;
  const EventCard(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.isPast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            isPast ? subTitle : "Pending",
            style: TextStyle(color: Color(0xFF868889)),
          )
        ],
      ),
    );
  }
}
