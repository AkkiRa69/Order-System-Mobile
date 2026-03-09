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
  String? _tableName;
  SubmittedOrder? _lastOrder;
  InvoiceModel? _lastInvoice;

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String get tableCode => _tableCode;
  String? get tableName => _tableName;
  SubmittedOrder? get lastOrder => _lastOrder;
  InvoiceModel? get lastInvoice => _lastInvoice;

  void setTableCode(String input) {
    _tableCode = _extractTableCode(input);
    _tableName = null;
    notifyListeners();
  }

  Future<bool> validateAndSetTableCode(String input) async {
    final extractedCode = _extractTableCode(input);
    if (extractedCode.isEmpty) {
      _errorMessage = 'Invalid QR code.';
      notifyListeners();
      return false;
    }

    try {
      final result = await _apiService.validateTableCode(extractedCode);
      final isValid = result['valid'] == true;
      if (!isValid) {
        _errorMessage =
            (result['message'] ?? 'Invalid table QR code').toString();
        notifyListeners();
        return false;
      }

      _tableCode = (result['table_code'] ?? extractedCode).toString();
      _tableName = result['table_name']?.toString();
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'Unable to verify table QR.';
      notifyListeners();
      return false;
    }
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
