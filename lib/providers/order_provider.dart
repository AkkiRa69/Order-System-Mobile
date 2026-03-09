import 'package:flutter/material.dart';
import 'package:grocery_store/model/order_model.dart';

class OrderProvider extends ChangeNotifier {
  int _orderNo = 9084;

  final List<OrderModel> _orderList = [];
  // final List<double> _totalPrice = [];
  List<OrderModel> get orderList => _orderList;
  // List get totalPrice => _totalPrice;

  int get orderNo => _orderNo;

  void setOrderNo() {
    _orderNo++;
    notifyListeners();
  }

  // void addPriceToTotalPrice(double item) {
  //   _totalPrice.add(item);
  //   notifyListeners();
  // }

  bool isEmpty() {
    return _orderList.isEmpty;
  }

  void addOrderToList(OrderModel item) {
    _orderList.add(item);
    notifyListeners();
  }
}
