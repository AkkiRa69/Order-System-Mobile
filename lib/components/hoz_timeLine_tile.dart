import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HozTimeLineTile extends StatelessWidget {
  final bool isFirst, isLast, isPast;
  final int index;
  final Widget child;
  const HozTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.06,
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        isFirst: isFirst,
        isLast: isLast,
        //decorate line stlye
        beforeLineStyle: LineStyle(
          color: isPast ? const Color(0xff6CC51D) : const Color(0xffffffff),
          thickness: 2,
        ),
        //decorate icon stlye
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          indicator: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                    isPast ? const Color(0xFF6CC51D) : const Color(0xffFFFFFF),
                shape: BoxShape.circle),
            child: child,
          ),
        ),
        
      ),
    );
  }
}
