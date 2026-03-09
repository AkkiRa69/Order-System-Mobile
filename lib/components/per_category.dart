import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_image.dart';

class PerCategory extends StatelessWidget {
  final List cates;
  final Color colors;
  final void Function()? onTap;
  final void Function(Offset)? onLongPress;
  final Color backColor;
  const PerCategory(
      {super.key,
      required this.cates,
      required this.colors,
      required this.backColor,
      required this.onTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (details) => onLongPress?.call(details.globalPosition),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: BoxDecoration(color: colors, shape: BoxShape.circle),
              padding: const EdgeInsets.all(15),
              child: AppImage(
                path: cates[1].toString(),
                fit: BoxFit.cover,
              ),
            ),
            Text(cates[0]),
          ],
        ),
      ),
    );
  }
}
