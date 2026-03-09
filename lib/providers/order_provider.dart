import 'package:flutter/material.dart';
import 'package:grocery_store/model/order_model.dart';
import 'package:grocery_store/model/table_order_model.dart';
import 'package:grocery_store/services/local_api_service.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider({LocalApiService? apiService})
      : _apiService = apiService ?? LocalApiService();

  final LocalApiService _apiService;
  int _orderNo = 9084;
  bool _isLoading = false;
  String? _errorMessage;
  final List<SubmittedOrder> _remoteOrders = [];

  final List<OrderModel> _orderList = [];
  // final List<double> _totalPrice = [];
  List<OrderModel> get orderList => _orderList;
  List<SubmittedOrder> get remoteOrders => _remoteOrders;
  // List get totalPrice => _totalPrice;

  int get orderNo => _orderNo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

  Future<void> fetchAllOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final rows = await _apiService.listOrders();
      _remoteOrders
        ..clear()
        ..addAll(rows.map(SubmittedOrder.fromJson));
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    }
  }
}
