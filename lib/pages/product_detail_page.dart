// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/product_detail.dart';
import 'package:grocery_store/components/product_image.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/review_page.dart';
import 'package:page_transition/page_transition.dart';

class ProductDetailPage extends StatefulWidget {
  final FruitModel fruit;
  final void Function()? onPressed;
  const ProductDetailPage({super.key, required this.fruit,required this.onPressed});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  void increment() {
    setState(() {
      widget.fruit.qty++;
    });
  }

  void decrement() {
    setState(() {
      if (widget.fruit.qty <= 0) {
        return;
      }
      widget.fruit.qty--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onPressed,
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          //image
          ProductImage(fruit: widget.fruit),
          //detail
          Expanded(
            child: ProductDetail(
              fruit: widget.fruit,
              increment: () => increment(),
              decrement: () => decrement(),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: ReviewPage(),
                        type: PageTransitionType.bottomToTop));
              },
            ),
          ),
        ],
      ),
    );
  }
}
