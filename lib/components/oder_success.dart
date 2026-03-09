import 'package:flutter/material.dart';

class OrderSuccess extends StatelessWidget {
  final String title, subTitle;
  const OrderSuccess({super.key,required this.subTitle,required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 95),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/bag1.png",
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
             Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
