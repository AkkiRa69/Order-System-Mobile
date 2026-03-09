import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/my_text_field.dart';
import 'package:grocery_store/helper/util.dart';
import 'package:grocery_store/model/address_model.dart';
import 'package:grocery_store/providers/address_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddAddressPage extends StatelessWidget {
  AddAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F9),
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xffffffff),
      title: const Text("Add Address"),
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController phone = TextEditingController();

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 25),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            MyTextField(
              controller: name,
              hintText: "Name",
              icon: CupertinoIcons.person_alt_circle,
            ),
            MyTextField(
              controller: address,
              hintText: "Address",
              icon: CupertinoIcons.location_circle,
            ),
            MyTextField(
              controller: city,
              hintText: "City",
              icon: CupertinoIcons.map,
            ),
            MyTextField(
              controller: zipCode,
              hintText: "Zip code",
              icon: CupertinoIcons.keyboard,
            ),
            MyTextField(
              controller: country,
              hintText: "Country",
              icon: Icons.location_on,
            ),
            MyTextField(
              controller: phone,
              hintText: "Phone number",
              icon: CupertinoIcons.phone,
            ),
            fackeToggle("Save this address"),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      color: const Color(0xffF4F5F9),
      child: LinearButton(
        text: "Add address",
        onPressed: () {
          if (name.text.isEmpty ||
              address.text.isEmpty ||
              city.text.isEmpty ||
              zipCode.text.isEmpty ||
              country.text.isEmpty ||
              phone.text.isEmpty) {
            return snackBar(context);
          }
          AddressModel add = AddressModel(
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

          context.read<AddressProvider>().addAddressToList(add);
          Get.snackbar("Message", "Address added successfully.");
        },
      ),
    );
  }
}
