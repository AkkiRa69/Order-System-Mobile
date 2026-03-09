import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyOrderTimelineTile extends StatelessWidget {
  final bool isFirst, isLast, isPast;

  final String title, date;
  const MyOrderTimelineTile({
    super.key,
    required this.isFirst,
    required this.date,
    required this.isLast,
    required this.isPast,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        //decorate line stlye
        beforeLineStyle: LineStyle(
          color: isPast ? Color(0xff28B446) : Color(0xff868889),
          thickness: 2,
        ),
        //decorate icon stlye
        indicatorStyle: IndicatorStyle(
            width: 12,
            height: 12,
            indicator: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPast ? Color(0xff28B446) : Color(0xff868889),
              ),
            )),
        endChild: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isPast ? date : "pending",
                style: TextStyle(color: Color(0xff868889)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
