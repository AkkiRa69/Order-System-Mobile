// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/per_category.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/product_page.dart';
import 'package:page_transition/page_transition.dart';

class CategoryPage extends StatelessWidget {
  final List cates;
  final List<Color> colors;
  final List<FruitModel> fruits;
  CategoryPage(
      {super.key,
      required this.cates,
      required this.colors,
      required this.fruits});
  void nvagateToCategory(BuildContext context, int index) {
    final categoryName = cates[index][0].toString();
    final filteredProducts = fruits
        .where((fruit) =>
            (fruit.categoryName ?? '').toLowerCase() ==
            categoryName.toLowerCase())
        .toList();

    Navigator.push(
        context,
        PageTransition(
            child: ProductPage(
              title: categoryName,
              fruits: filteredProducts,
            ),
            type: PageTransitionType.bottomToTop));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        centerTitle: true,
        title: Text("Categories"),
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
      body: Container(
        padding: EdgeInsets.all(15),
        child: GridView.builder(
          itemCount: cates.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return PerCategory(
              backColor: AppColor.appBarColor,
              onTap: () {
                nvagateToCategory(context, index);
              },
              cates: cates[index],
              colors: colors[index % colors.length],
            );
          },
        ),
      ),
    );
  }
}
