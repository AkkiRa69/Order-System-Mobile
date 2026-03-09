import 'package:flutter/material.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/constant/card_icon.dart';
import 'package:grocery_store/model/order_model.dart';
import 'package:grocery_store/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyTransactionPage extends StatelessWidget {
  const MyTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColor.appBarColor,
      title: const Text("My Transactions"),
    );
  }
}

Widget _buildBody(BuildContext context) {
  List<OrderModel> order = context.watch<OrderProvider>().orderList;
  return Column(
    children: [
      const SizedBox(
        height: 20,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: order.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.appBarColor,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(left: 17, right: 17, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Color(0xffF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: index % 2 == 0
                            ? Image.asset(CardIcons.masterCard)
                            : Image.asset(CardIcons.visaCard),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              index % 2 == 0 ? "Master Card" : "Visa card",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${DateFormat('MMMM dd yyyy').format(order[index].date)} at ${DateFormat('hh:mm a').format(order[index].date)}",
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "\$${order[index].itemPrice + 1.6}",
                    style: const TextStyle(
                        color: Color(0xff28B446),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  );
}
