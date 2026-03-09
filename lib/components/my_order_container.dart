// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:grocery_store/model/order_model.dart';
import 'package:intl/intl.dart';

class MyOrderContainer extends StatelessWidget {
  final OrderModel order;
  final bool isPast;
  const MyOrderContainer(
      {super.key, required this.order, required this.isPast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17),
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
                        "Order #${order.orderNo}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Placed on ${DateFormat('MMMM dd yyyy').format(order.date)}",
                        style: TextStyle(color: Color(0xFF868889)),
                      ),
                      Row(
                        children: [
                          Text(
                            "Items: ${order.itemCount}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Items: ${"\$" + (order.itemPrice + 1.6).toStringAsFixed(1)}",
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: Color(0xffEBEBEB),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: isPast ? Color(0xff28B446) : Color(0xff868889),
                    size: 12,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Order Delivered",
                    style: TextStyle(
                      color: Color(0xff868889),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                isPast
                    ? DateFormat('MMMM dd yyyy').format(order.date)
                    : "pending",
                style: TextStyle(
                  color: Color(0xff868889),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
