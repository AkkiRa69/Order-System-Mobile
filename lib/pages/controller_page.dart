import 'package:flutter/material.dart';
import 'package:grocery_store/components/my_bottom_nav_bar.dart';
import 'package:grocery_store/pages/cart_contoller_page.dart';
import 'package:grocery_store/pages/favorite_page.dart';
import 'package:grocery_store/pages/home_page.dart';
import 'package:grocery_store/pages/profile_page.dart';

// ignore: must_be_immutable
class ControllerPage extends StatefulWidget {
  const ControllerPage({
    super.key,
  });

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  final List<Widget> pages = [
    const HomePage(),
    const ProfilePage(),
    const FavoritePage(),
    const CartControllerPage(),
  ];

  late int index = 0;
  void changeIndex(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          IndexedStack(
            index: index,
            children: pages,
          ),
          if (index != 3) // Checking if not on ShoppingCartPage
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MyBottomNavBar(
                index: index,
                onTap: (value) {
                  changeIndex(value);
                },
              ),
            ),
        ],
      ),
    );
  }
}
