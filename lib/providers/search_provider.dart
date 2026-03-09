import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  final List<String> _searchList = [
    "Fish",
    "Apple",
    "Eggs",
    "Cow Meat",
    "Pork Meat",
    "Pizza",
  ];
  final List<String> _discover = [
    "Fresh Grocery",
    "Bananas",
    "Cheetos",
    "Prime",
    "Vegetables",
    "Fruits",
    "Discount Itmes",
    "Fresh Eggs",
  ];

  List<String> get searchList => _searchList;

  List<String> get discover => _discover;

  void addTextToSearchHis(String item) {
    _searchList.add(item);
    notifyListeners();
  }

  void clearHis() {
    _searchList.clear();
    notifyListeners();
  }

  void clearDis() {
    _discover.clear();
    notifyListeners();
  }
}
