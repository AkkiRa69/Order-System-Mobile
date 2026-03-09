import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String icon, text;
  final void Function()? click;
  final double size;
  final bool isSign;
  const MyListTile(
      {super.key,
      required this.click,
      required this.icon,
      required this.text,
      this.size = 25,
      this.isSign = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  child: Image.asset(
                    icon,
                    height: size,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    text,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: click,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: isSign ? Colors.transparent : Color(0xff868889),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
