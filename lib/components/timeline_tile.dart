import 'package:flutter/material.dart';
import 'package:grocery_store/components/event_card.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst, isLast, isPast;

  final String icon, title, subTitle;
  const MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        //decorate line stlye
        beforeLineStyle: LineStyle(
          color: isPast ? const Color(0xff28B446) : const Color(0xff868889),
          thickness: 3,
        ),
        //decorate icon stlye
        indicatorStyle: IndicatorStyle(
          width: 66,
          height: 66,
          indicator: Container(
            decoration: BoxDecoration(
                color:
                    isPast ? const Color(0xFFEBFFD7) : const Color(0xffF5F5F5),
                shape: BoxShape.circle),
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              icon,
              color: isPast ? const Color(0xff28B446) : const Color(0xff868889),
            ),
          ),
        ),
        endChild: EventCard(
          title: title,
          subTitle: subTitle,
          isPast: isPast,
        ),
      ),
    );
  }
}
