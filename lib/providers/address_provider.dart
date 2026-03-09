import 'package:flutter/material.dart';
import 'package:grocery_store/model/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final List<AddressModel> _addressList = [
    AddressModel(
        name: "San Monyakkhara",
        address: "Khan Tuol Kork",
        city: "Phnom Penh",
        zipCode: "+855",
        country: "Cambodia",
        phone: "93 822 805"),
  ];

  List<AddressModel> get addressList => _addressList;

  void addAddressToList(AddressModel add) {
    _addressList.add(add);
    notifyListeners();
  }

  void removeAddressFromList(AddressModel add) {
    _addressList.remove(add);
    notifyListeners();
  }
}
