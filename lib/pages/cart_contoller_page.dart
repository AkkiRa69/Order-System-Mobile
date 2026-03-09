import 'package:flutter/material.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/pages/order_success.dart';
import 'package:grocery_store/pages/shopping_cart_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CartControllerPage extends StatefulWidget {
  const CartControllerPage({super.key});

  @override
  State<CartControllerPage> createState() => _CartControllerPageState();
}

class _CartControllerPageState extends State<CartControllerPage> {
  final List pages = [
    const ShoppingCartPage(),
    OrderSuccessPage(
        appBarTitle: 'Shopping Cart',
        subtitle: "You will get a response within a few minutes.",
        title: "Your cart is empty !",
        btnText: 'Start shopping',
        onPressed: (BuildContext context) {
          Navigator.push(
              context,
              PageTransition(
                  child: const ControllerPage(),
                  type: PageTransitionType.leftToRight));
        }),
  ];

  @override
  Widget build(BuildContext context) {
    int cartEmpty = context.watch<FruitProvider>().isCartEmpty();

    return Scaffold(
      body: pages[cartEmpty],
    );
  }
}
