import 'package:flutter/material.dart';

class IntroImage extends StatelessWidget {
  final String images, title,des;
  const IntroImage({
    super.key,
    required this.images,
    required this.title,
    required this.des,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Image.asset(
              "assets/images/${images}",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Text(
            des,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
