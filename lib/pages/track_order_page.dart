// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/components/timeline_tile.dart';
import 'package:grocery_store/helper/util.dart';
import 'package:grocery_store/model/order_model.dart';
import 'package:grocery_store/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrackOrderPage extends StatefulWidget {
  const TrackOrderPage({super.key});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  bool orderPlacedPast = false;

  bool orderConfirmedPast = false;

  bool orderShippedPast = false;

  bool outForDeliveryPast = false;

  bool orderDeliveredPast = false;

  @override
  void initState() {
    super.initState();

    _startProgress();
  }

  final player = AudioPlayer();

  String audioPath = "audios/ding.mp3"; // Corrected path

  void playSound() {
    player.play(AssetSource(audioPath));
  }

  void _startProgress() async {
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

    mySnackBar("Message", "Your order has been delivered to your front door.",
        Icons.shopping_cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Text("Track Order"),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<OrderModel> orders = context.read<OrderProvider>().orderList;
    return Container(
      child: ListView(
        children: [
          //order
          Container(
            margin: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEBFFD7),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Image.asset(
                    "assets/icons/box1.png",
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
                      "Placed on ${DateFormat('MMMM dd yyyy').format(orders[0].date)}",
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
                          "Items: ${"\$${(orders[orders.length - 1].itemPrice + 1.6).toStringAsFixed(2)}"}",
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
          ),

          //timeline tile
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFFFFF),
            ),
            margin: EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              children: [
                MyTimeLineTile(
                  isFirst: true,
                  isLast: false,
                  isPast: orderPlacedPast,
                  icon: "assets/icons/box2.png",
                  title: "Order Placed",
                  subTitle: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                ),
                MyTimeLineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: orderConfirmedPast,
                  icon: "assets/icons/checked.png",
                  title: "Order Confirmed",
                  subTitle: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                ),
                MyTimeLineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: orderShippedPast,
                  icon: "assets/icons/location.png",
                  title: "Order Shipped",
                  subTitle: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                ),
                MyTimeLineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: outForDeliveryPast,
                  icon: "assets/icons/truck.png",
                  title: "Out for Delivery",
                  subTitle: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                ),
                MyTimeLineTile(
                  isFirst: false,
                  isLast: true,
                  isPast: orderDeliveredPast,
                  icon: "assets/icons/deliver.png",
                  title: "Order Delivered",
                  subTitle: DateFormat('MMMM dd yyyy').format(DateTime.now()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
