import 'package:flutter/material.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/model/table_order_model.dart';
import 'package:grocery_store/services/local_api_service.dart';

class TableOrderProvider extends ChangeNotifier {
  TableOrderProvider({LocalApiService? apiService})
      : _apiService = apiService ?? LocalApiService();

  final LocalApiService _apiService;

  bool _isSubmitting = false;
  String? _errorMessage;
  String _tableCode = '';
  SubmittedOrder? _lastOrder;
  InvoiceModel? _lastInvoice;

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String get tableCode => _tableCode;
  SubmittedOrder? get lastOrder => _lastOrder;
  InvoiceModel? get lastInvoice => _lastInvoice;

  void setTableCode(String input) {
    _tableCode = _extractTableCode(input);
    notifyListeners();
  }

  Future<bool> submitCartOrder({
    required List<FruitModel> cartItems,
    String? notes,
  }) async {
    final normalizedTableCode = _extractTableCode(_tableCode);
    if (normalizedTableCode.isEmpty) {
      _errorMessage = 'Table code is required.';
      notifyListeners();
      return false;
    }

    final payloadItems = cartItems
        .where((item) => item.id != null && item.qty > 0)
        .map(
          (item) => {
            'product_id': item.id,
            'quantity': item.qty,
          },
        )
        .toList();

    if (payloadItems.isEmpty) {
      _errorMessage = 'Cart is empty.';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orderJson = await _apiService.submitTableOrder(
        tableCode: normalizedTableCode,
        items: payloadItems,
        notes: notes,
      );
      final order = SubmittedOrder.fromJson(orderJson);
      final invoiceJson = await _apiService.getInvoice(order.id);

      _lastOrder = order;
      _lastInvoice = InvoiceModel.fromJson(invoiceJson);
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isSubmitting = false;
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  String _extractTableCode(String rawInput) {
    final trimmed = rawInput.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.queryParameters.containsKey('table')) {
      return uri.queryParameters['table']!.trim();
    }

    return trimmed;
  }
}
