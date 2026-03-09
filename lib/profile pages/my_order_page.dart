// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/components/my_order_container.dart';
import 'package:grocery_store/components/my_order_timeline_tile.dart';
import 'package:grocery_store/model/order_model.dart';
import 'package:grocery_store/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  bool orderPlacedPast = false;

  bool orderConfirmedPast = false;

  bool orderShippedPast = false;

  bool outForDeliveryPast = false;

  bool orderDeliveredPast = false;

  final player = AudioPlayer();

  String audioPath = "audios/ding.mp3";
  // Corrected path
  void playSound() {
    player.play(AssetSource(audioPath));
  }

  @override
  void initState() {
    super.initState();

    List<OrderModel> orders = context.read<OrderProvider>().orderList;
    bool isEmpty = orders.isEmpty;

    if (!isEmpty) {
      _startProgress(false);
    }
  }

  void _startProgress(bool isEmpty) async {
    if (isEmpty == true) {
      return;
    }

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      orderPlacedPast = true;
    });
    playSound(); // Play sound after order is placed

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      orderConfirmedPast = true;
    });
    playSound(); // Play sound after order is confirmed

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      orderShippedPast = true;
    });
    playSound(); // Play sound after order is shipped

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      outForDeliveryPast = true;
    });
    playSound(); // Play sound after order is out for delivery

    await Future.delayed(Duration(seconds: 3));
    setState(() {
      orderDeliveredPast = true;
    });
    playSound(); // Play sound after order is delivered

    player.stop(); // Stop audio after order is delivered

    Get.snackbar(
      "Message",
      "Your order has been delivered to your front door.",
      colorText: Colors.black,
      icon: Icon(
        Icons.shopping_cart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xffffffff),
      title: Text("My Order"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Image.asset(
            "assets/icons/filter.png",
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    List<OrderModel> orders = context.read<OrderProvider>().orderList;

    if (orders.isEmpty) {
      return Container(); // Return an empty container if orders list is empty
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(17),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEBFFD7),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/icons/box2.png",
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Order #${orders[orders.length - 1].orderNo}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Placed on ${DateFormat('MMMM dd yyyy').format(orders[orders.length - 1].date)}",
                              style: TextStyle(color: Color(0xFF868889)),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Items: ${orders[orders.length - 1].itemCount}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Items: ${"\$" + (orders[orders.length - 1].itemPrice + 1.6).toStringAsFixed(1)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/icons/expand.png",
                      height: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    color: Color(0xffEBEBEB),
                    thickness: 2,
                  ),
                ),
                MyOrderTimelineTile(
                  isFirst: true,
                  isLast: false,
                  isPast: orderPlacedPast,
                  title: "Order Placed",
                  date: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                ),
                MyOrderTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: orderConfirmedPast,
                  date: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                  title: "Order Confirmed",
                ),
                MyOrderTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: orderShippedPast,
                  date: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                  title: "Order Shipped",
                ),
                MyOrderTimelineTile(
                  isFirst: false,
                  isLast: false,
                  date: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                  isPast: outForDeliveryPast,
                  title: "Out for Delivery",
                ),
                MyOrderTimelineTile(
                  isFirst: false,
                  isLast: true,
                  date: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                  isPast: orderDeliveredPast,
                  title: "Order Delivered",
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MyOrderContainer(
                  order: orders[index],
                  isPast: orderDeliveredPast,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
