// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/components/my_list_tile.dart';
import 'package:grocery_store/pages/catalog_crud_page.dart';
import 'package:grocery_store/pages/login_page.dart';
import 'package:grocery_store/profile%20pages/Transactions_page.dart';
import 'package:grocery_store/profile%20pages/about_me_page.dart';
import 'package:grocery_store/profile%20pages/credit_card_page.dart';
import 'package:grocery_store/profile%20pages/my_Address_page.dart';
import 'package:grocery_store/profile%20pages/my_fav_page.dart';
import 'package:grocery_store/profile%20pages/my_order_page.dart';
import 'package:grocery_store/profile%20pages/notification_page.dart';
import 'package:page_transition/page_transition.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List listTile = [
    ["About me", "assets/icons/aboutme.png"],
    ["My Orders", "assets/icons/myorder.png"],
    ["My Favorites", "assets/icons/myfav.png"],
    ["My Address", "assets/icons/myaddress.png"],
    ["Credit Cards", "assets/icons/creditcards.png"],
    ["Transactions", "assets/icons/transaction.png"],
    ["Notifications", "assets/icons/notifications.png"],
    ["Catalog CRUD", "assets/icons/grocery.png"],
    ["Sign out", "assets/icons/signout.png"],
  ];

  final List<Function> funcList = [
    aboutMe,
    myOrder,
    myFav,
    myAddress,
    creditCard,
    transaction,
    notification,
    catalogCrud,
    signOut,
  ];
  static void aboutMe(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: AboutMePage(), type: PageTransitionType.rightToLeft));
  }

  static void myOrder(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: MyOrderPage(), type: PageTransitionType.rightToLeft));
  }

  static void myFav(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: MyFavPage(), type: PageTransitionType.rightToLeft));
  }

  static void myAddress(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: MyAddressPage(), type: PageTransitionType.rightToLeft));
  }

  static void creditCard(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: MyCreditCardPage(), type: PageTransitionType.rightToLeft));
  }

  static void transaction(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: MyTransactionPage(), type: PageTransitionType.rightToLeft));
  }

  static void notification(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: NotificationPage(), type: PageTransitionType.rightToLeft));
  }

  static void catalogCrud(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: const CatalogCrudPage(),
            type: PageTransitionType.rightToLeft));
  }

  static void signOut(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            child: LoginPage(), type: PageTransitionType.rightToLeft));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                color: Color(0xFFFFFFFF),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.15),
                  alignment: Alignment.center,
                  color: Color(0xFFF4F5F9),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == 4) {
                        return MyListTile(
                          click: () => funcList[index](context),
                          icon: listTile[index][1],
                          text: listTile[index][0],
                          size: 18,
                        );
                      }
                      if (index == 8) {
                        return MyListTile(
                          click: () => funcList[index](context),
                          icon: listTile[index][1],
                          text: listTile[index][0],
                          isSign: true,
                        );
                      } else {
                        return MyListTile(
                            click: () => funcList[index](context),
                            icon: listTile[index][1],
                            text: listTile[index][0]);
                      }
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: listTile.length,
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Container(
              alignment: Alignment.center,
              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 114,
                        width: 114,
                      ),
                      CircleAvatar(
                        maxRadius: 55,
                        backgroundImage: AssetImage(
                          "assets/images/akkhara.png",
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Image.asset(
                          "assets/icons/camera.png",
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "San Monyakkhara",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "sanmonyakkhara99@gmail.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
