// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/shopping_cart_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final FruitModel fruit;
  final void Function()? increment;
  final void Function()? decrement;
  final void Function()? onTap;
  const ProductDetail(
      {super.key,
      required this.fruit,
      required this.onTap,
      required this.decrement,
      required this.increment});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

bool isFav = false;

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Color(0xFFF4F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 26),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${widget.fruit.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final provider = context.read<FruitProvider>();
                    if (widget.fruit.isFav) {
                      provider.removeProductFavorite(widget.fruit);
                    } else {
                      provider.addProductToFavorites(widget.fruit);
                    }
                    setState(() {});
                  },
                  icon: widget.fruit.isFav
                      ? Icon(Icons.favorite, color: Colors.pink)
                      : Icon(Icons.favorite_border),
                ),
              ],
            ),
            Text(
              widget.fruit.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.fruit.weight,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: Row(
                children: [
                  Text(
                    widget.fruit.rate.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  for (int i = 0; i < widget.fruit.rate; i++)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 20,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  Text(
                    "(${widget.fruit.review} reviews)",
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            //description
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                widget.fruit.description,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            //quantity
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quantity",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        color: Colors.green,
                        onPressed: widget.decrement,
                        icon: Icon(
                          CupertinoIcons.minus,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: Text(
                          (widget.fruit.qty).toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      IconButton(
                        color: Colors.green,
                        onPressed: widget.increment,
                        icon: Icon(
                          CupertinoIcons.add,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Add to cart button
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    // Colors.white,
                    Color.fromARGB(255, 190, 249, 192),
                    Color.fromARGB(255, 136, 241, 140),
                    const Color.fromARGB(255, 95, 236, 100),
                  ],
                ),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(18),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: Duration(milliseconds: 300),
                          child: ShoppingCartPage(),
                          type: PageTransitionType.rightToLeft));
                  context.read<FruitProvider>().addProductToCart(widget.fruit);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      child: Text(
                        "Add to cart",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
