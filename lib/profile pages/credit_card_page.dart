// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/components/address_text_field.dart';
import 'package:grocery_store/components/card_tile.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/constant/card_icon.dart';
import 'package:grocery_store/helper/util.dart';
import 'package:grocery_store/model/card_model.dart';
import 'package:grocery_store/profile%20pages/add_card_page.dart';
import 'package:grocery_store/providers/card_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyCreditCardPage extends StatelessWidget {
  MyCreditCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F9),
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return myAppBar(() {
      Navigator.push(
          context,
          PageTransition(
              child: AddCardPage(), type: PageTransitionType.rightToLeft));
    }, "My Cards");
  }

  TextEditingController name = TextEditingController();
  TextEditingController cardNum = TextEditingController();
  TextEditingController expires = TextEditingController();
  TextEditingController cvv = TextEditingController();

  int currentIndex = 0;

  Widget _buildBody(BuildContext context) {
    List<CardModel> card = context.watch<CardProvider>().cardList;
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 17, vertical: 17),
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //default text
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEBFFD7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "DEFAULT",
                    style: TextStyle(
                      color: Color(0xff6CC51D),
                    ),
                  ),
                ),

                //new address
                CardTile(
                  index: card.length - 1,
                  card: card[card.length - 1],
                  icon: currentIndex % 2 == 0
                      ? CardIcons.masterCard
                      : CardIcons.visaCard,
                ),
                Divider(
                  color: Color(0xffEBEBEB),
                ),
                //text field
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                  child: Column(
                    children: [
                      AddressTextField(
                        controller: name,
                        hintText: "Name",
                        icon: CupertinoIcons.person_alt_circle,
                      ),
                      AddressTextField(
                        controller: cardNum,
                        hintText: "Card number",
                        icon: CupertinoIcons.creditcard,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AddressTextField(
                              controller: expires,
                              hintText: "Expires date",
                              icon: CupertinoIcons.calendar,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: AddressTextField(
                              controller: cvv,
                              hintText: "Cvv",
                              icon: CupertinoIcons.lock,
                            ),
                          ),
                        ],
                      ),
                      fackeToggle("Make default")
                    ],
                  ),
                ),
                //make deault
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: card.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              currentIndex = index;
              return Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(left: 17, right: 17, bottom: 10),
                child: CardTile(
                  card: card[index],
                  icon: index % 2 == 0
                      ? CardIcons.masterCard
                      : CardIcons.visaCard,
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    List<CardModel> card = context.watch<CardProvider>().cardList;
    return BottomAppBar(
      elevation: 0,
      color: Colors.transparent,
      child: LinearButton(
        text: "Save settings",
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
          name.value = TextEditingValue.empty;
          cardNum.value = TextEditingValue.empty;
          cvv.value = TextEditingValue.empty;
          expires.value = TextEditingValue.empty;
          Get.snackbar("Message", "Card updated successfully.");
          context
              .read<CardProvider>()
              .removeCardFromList(card[card.length - 1]);

          context.read<CardProvider>().addCardToList(cardModel);
        },
      ),
    );
  }
}
