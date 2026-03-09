import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_image.dart';
import 'package:grocery_store/model/fruit_model.dart';

class ProductImage extends StatelessWidget {
  final FruitModel fruit;
  const ProductImage({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.52,
          // color: Colors.blue,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          color: fruit.color,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.48,
          decoration: BoxDecoration(color: fruit.color, shape: BoxShape.circle),
        ),
        Positioned(
          bottom: 0,
          child: AppImage(path: fruit.image, height: 300),
        ),
      ],
    );
  }
}
