import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/my_text_field.dart';
import 'package:grocery_store/constant/shape.dart';
import 'package:grocery_store/helper/util.dart';
import 'package:grocery_store/model/card_model.dart';
import 'package:grocery_store/providers/card_provider.dart';
import 'package:grocery_store/widgets/card_num_display_widget.dart';
import 'package:grocery_store/widgets/cvv_display_widget.dart';
import 'package:grocery_store/widgets/epires_display_widget.dart';
import 'package:grocery_store/widgets/name_display_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F9),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return myAppBar(() {}, "My Cards");
  }

  TextEditingController name = TextEditingController();

  TextEditingController cardNum = TextEditingController();

  TextEditingController expires = TextEditingController();

  TextEditingController cvv = TextEditingController();

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          //card
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 190,
            // padding: const EdgeInsets.all(17),
            margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xff6CC51D),
                  Color.fromARGB(255, 178, 241, 122),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/icons/master.png",
                            height: 34,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              CardNumDisplayWidget(controller: cardNum),
                              CvvDisplayWidget(controller: cvv),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "CARD HOLDER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              NameDisplayWidget(controller: name),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "EXPIRES",
                                  style: TextStyle(color: Colors.white),
                                ),
                                ExpiresDisplayWidget(controller: expires),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 70,
                  top: 60,
                  child: Image.asset(
                    "assets/icons/Polygon_red.png",
                    height: 20,
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 40,
                  child: Image.asset(
                    "assets/icons/Polygon_yellow.png",
                    height: 14,
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        circleShape(),
                        squreShape(),
                      ],
                    ),
                    circleShape(),
                  ],
                ),
              ],
            ),
          ),
          //text field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              children: [
                MyTextField(
                  hintText: "Name on the card",
                  icon: Icons.person_outline_sharp,
                  controller: name,
                ),
                MyTextField(
                  hintText: "Card number",
                  icon: Icons.credit_card,
                  controller: cardNum,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: "Month / Year",
                        icon: Icons.calendar_month_outlined,
                        controller: expires,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: MyTextField(
                        hintText: "CVV",
                        icon: Icons.lock_outline_rounded,
                        controller: cvv,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: fackeToggle("Save this card"),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: LinearButton(
        onPressed: () {
          if (name.text.isEmpty ||
              cardNum.text.isEmpty ||
              expires.text.isEmpty ||
              cvv.text.isEmpty) {
            return snackBar(context);
          }
          CardModel cardModel = CardModel(
            name: name.text,
            cardNum: int.parse(cardNum.text),
            cvv: int.parse(cvv.text),
            expires: int.parse(expires.text),
          );
          Get.snackbar("Message", "Card added successfully.");
          name.value = TextEditingValue.empty;
          cardNum.value = TextEditingValue.empty;
          cvv.value = TextEditingValue.empty;
          expires.value = TextEditingValue.empty;

          context.read<CardProvider>().addCardToList(cardModel);
        },
        text: "Add credit card",
      ),
    );
  }
}
