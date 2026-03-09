// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/banner.dart';
import 'package:grocery_store/components/per_category.dart';
import 'package:grocery_store/components/product.dart';
import 'package:grocery_store/components/search_bar.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/category_page.dart';
import 'package:grocery_store/pages/filter_page.dart';
import 'package:grocery_store/pages/product_page.dart';
import 'package:grocery_store/pages/product_detail_page.dart';
import 'package:grocery_store/pages/search_tap_page.dart';
import 'package:grocery_store/pages/table_order_checkout_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final List<Color> colors = [
    Color(0xFFE6F2EA),
    Color(0xFFFFE9E5),
    Color(0xFFFFF6E3),
    Color(0xFFF3EFFA),
    Color(0xFFDCF4F5),
    Color(0xFFFFE8F2),
    Color(0xFFD2EFFF),
  ];

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
    super.build(context);
    final fruitProvider = context.watch<FruitProvider>();
    List<FruitModel> fruits = fruitProvider.fruitList;
    final categories = fruitProvider.categories;
    List cates = fruitProvider.cates;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fruitProvider.shoppingCart.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 72),
              child: FloatingActionButton.extended(
                backgroundColor: const Color(0xFF6CC51D),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const TableOrderCheckoutPage(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                icon:
                    const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                label: Text(
                  'Checkout (${fruitProvider.shoppingCart.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFF4F5F9),
              ],
            ),
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              //search bar
              MySearchBar(
                searchTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: SearchTapPage(),
                        type: PageTransitionType.leftToRight),
                  );
                },
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: FilterPage(),
                      type: PageTransitionType.bottomToTop,
                      duration: Duration(
                          milliseconds: 300), // Adjust duration as needed
                      reverseDuration: Duration(
                          milliseconds:
                              300), // Adjust reverse duration as needed
                      curve:
                          Curves.easeInOut, // Add a curve for smooth animation
                    ),
                  );
                },
              ),

              //banner
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: MyBanner(),
              ),

              //Categories
              Padding(
                padding: const EdgeInsets.only(left: 17, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: CategoryPage(
                                  fruits: fruits,
                                  cates: cates,
                                  colors: colors,
                                ),
                                type: PageTransitionType.bottomToTop));
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              Container(
                height: 90,
                padding: const EdgeInsets.only(left: 17),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < categories.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: PerCategory(
                          backColor: Colors.transparent,
                          cates: [categories[i].name, categories[i].icon],
                          colors: colors[i % colors.length],
                          onTap: () {
                            final productsByCategory = context
                                .read<FruitProvider>()
                                .productsByCategoryName(categories[i].name);
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: ProductPage(
                                        fruits: productsByCategory,
                                        title: categories[i].name),
                                    type: PageTransitionType.bottomToTop));
                          },
                        ),
                      ),
                  ],
                ),
              ),

              //features product
              Padding(
                padding: const EdgeInsets.only(left: 17, top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Features Product",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ProductPage(
                                    fruits: fruits, title: "Vegetables"),
                                type: PageTransitionType.bottomToTop));
                      },
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              if (fruitProvider.isLoading && fruits.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (fruitProvider.errorMessage != null && fruits.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        fruitProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<FruitProvider>().fetchInitialData(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (fruits.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('No products available')),
                )
              else
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 17),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: (fruits.length / 2).ceil(),
                  itemBuilder: (context, index) {
                    final List<Widget> cards = [
                      for (final fruit in fruits) buildProduct(fruit),
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
                          SizedBox(
                              width: 17), // Horizontal spacing between columns
                          if (secondIndex < fruits.length)
                            Expanded(
                              child: SizedBox(
                                height: height,
                                child: cards[secondIndex],
                              ),
                            )
                          else
                            Expanded(
                              child: SizedBox(height: height),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
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

  @override
  bool get wantKeepAlive => true;
}
