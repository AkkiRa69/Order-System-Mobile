// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/components/address_text_field.dart';
import 'package:grocery_store/components/address_tile.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/helper/util.dart';
import 'package:grocery_store/model/address_model.dart';
import 'package:grocery_store/profile%20pages/add_address_page.dart';
import 'package:grocery_store/providers/address_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  bool isSwitch = false;

  void switched(bool value) {
    setState(() {
      isSwitch = value;
    });
  }

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F5F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  AppBar _buildAppBar() {
    return myAppBar(() {
      Navigator.push(
          context,
          PageTransition(
              child: AddAddressPage(), type: PageTransitionType.rightToLeft));
    }, "My Address");
  }

  Widget _buildBody(BuildContext context) {
    List<AddressModel> add = context.watch<AddressProvider>().addressList;
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
                AddressTile(
                  color: Color(0xffEBFFD7),
                  add: add[add.length - 1],
                  icon: "assets/icons/address.png",
                ),
                //container
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
                        controller: address,
                        hintText: "Address",
                        icon: CupertinoIcons.location_circle,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AddressTextField(
                              controller: city,
                              hintText: "City",
                              icon: CupertinoIcons.map,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: AddressTextField(
                              controller: zipCode,
                              hintText: "Zip code",
                              icon: CupertinoIcons.keyboard,
                            ),
                          ),
                        ],
                      ),
                      AddressTextField(
                        controller: country,
                        hintText: "Country",
                        icon: Icons.location_on,
                      ),
                      AddressTextField(
                        controller: phone,
                        hintText: "Phone number",
                        icon: CupertinoIcons.phone,
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
            itemCount: add.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (add.isEmpty) {
                return Container();
              } else {
                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(left: 17, right: 17, bottom: 10),
                  child: AddressTile(
                    color: Color(0xffEBFFD7),
                    add: add[index],
                    icon: "assets/icons/address.png",
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    List<AddressModel> add = context.watch<AddressProvider>().addressList;
    return BottomAppBar(
      color: Color(0xffF4F5F9),
      elevation: 0,
      child: LinearButton(
        text: "Save settings",
        onPressed: () {
          if (name.text.isEmpty ||
              address.text.isEmpty ||
              city.text.isEmpty ||
              zipCode.text.isEmpty ||
              country.text.isEmpty ||
              phone.text.isEmpty) {
            return snackBar(context);
          }
          AddressModel newAdd = AddressModel(
              name: name.text,
              address: address.text,
              city: city.text,
              zipCode: zipCode.text,
              country: country.text,
              phone: phone.text);

          name.value = TextEditingValue.empty;
          address.value = TextEditingValue.empty;
          city.value = TextEditingValue.empty;
          zipCode.value = TextEditingValue.empty;
          phone.value = TextEditingValue.empty;
          country.value = TextEditingValue.empty;

          context
              .read<AddressProvider>()
              .removeAddressFromList(add[add.length - 1]);
          context.read<AddressProvider>().addAddressToList(newAdd);
        },
      ),
    );
  }
}
