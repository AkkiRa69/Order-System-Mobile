// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_image.dart';
import 'package:grocery_store/model/fruit_model.dart';

class Product extends StatefulWidget {
  final FruitModel fruits;
  final bool isFav;
  final void Function()? onPressed;
  final void Function()? onTap;
  final void Function(Offset)? onLongPress;
  const Product({
    super.key,
    required this.fruits,
    required this.onTap,
    required this.onPressed,
    required this.isFav,
    this.onLongPress,
  });

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPressStart: (details) => widget.onLongPress?.call(
        details.globalPosition,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: widget.onPressed,
                  icon: widget.isFav
                      ? Icon(Icons.favorite, color: Colors.pink)
                      : Icon(Icons.favorite_border),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 100,
                  width: 120,
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 80,
                    width: 80,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: widget.fruits.color,
                      // borderRadius: BorderRadius.circular(50),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  child: SizedBox(
                    height: 80,
                    width: 110,
                    child: AppImage(
                      path: widget.fruits.image,
                      height: 80,
                      width: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "\$" + widget.fruits.price.toStringAsFixed(2),
              style: TextStyle(
                color: Color(0xFF6CC51D),
              ),
            ),
            Text(
              widget.fruits.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.fruits.weight,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 5),
            Divider(
              color: Colors.grey[200],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: IconButton(
                  onPressed: widget.onTap,
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/shop_bag.png",
                        height: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Add to cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
