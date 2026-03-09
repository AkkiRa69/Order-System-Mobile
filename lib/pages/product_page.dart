// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:grocery_store/components/product.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/product_detail_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final List<FruitModel> fruits;
  final String title;
  const ProductPage({super.key, required this.fruits, required this.title});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  void navigateToProductDetail(BuildContext context, FruitModel fruits) {
    Navigator.push(
      context,
      PageTransition(
        child: ProductDetailPage(
          fruit: fruits,
          onPressed: () => Navigator.pop(context),
        ),
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/icons/filter.png",
              color: Colors.black,
            ),
          )
        ],
      ),
      body: widget.fruits.isEmpty
          ? const Center(child: Text('No products found for this category.'))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 17),
              itemCount: (widget.fruits.length / 2).ceil(),
              itemBuilder: (context, index) {
                final List<Widget> cards = [
                  for (final fruit in widget.fruits) buildProduct(fruit),
                ];
                int firstIndex = index * 2;
                int secondIndex = firstIndex + 1;
                double height = 280;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: height,
                          child: cards[firstIndex],
                        ),
                      ),
                      SizedBox(width: 17), // Horizontal spacing between columns
                      if (secondIndex < cards.length)
                        Expanded(
                          child: SizedBox(
                            height: height,
                            child: cards[secondIndex],
                          ),
                        )
                      else
                        Expanded(
                          child: SizedBox(
                              height:
                                  height), // Placeholder for layout alignment
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget buildProduct(FruitModel fruits) {
    return Product(
      onPressed: () {
        final provider = context.read<FruitProvider>();
        if (fruits.isFav) {
          provider.removeProductFavorite(fruits);
        } else {
          provider.addProductToFavorites(fruits);
        }
      },
      isFav: fruits.isFav,
      fruits: fruits,
      cartQty: context.watch<FruitProvider>().cartQuantity(fruits),
      onAddToCart: () {
        context.read<FruitProvider>().addProductToCart(fruits);
      },
      onIncrementQty: () {
        context.read<FruitProvider>().incrementCartQuantity(fruits);
      },
      onDecrementQty: () {
        context.read<FruitProvider>().decrementCartQuantity(fruits);
      },
      onTap: () {
        navigateToProductDetail(context, fruits);
      },
    );
  }
}
