class SubmittedOrderItem {
  SubmittedOrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  factory SubmittedOrderItem.fromJson(Map<String, dynamic> json) {
    return SubmittedOrderItem(
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      productName: (json['product_name'] ?? '').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0,
    );
  }
}

class SubmittedOrder {
  SubmittedOrder({
    required this.id,
    required this.tableName,
    required this.status,
    required this.invoiceNumber,
    required this.subtotal,
    required this.taxAmount,
    required this.serviceCharge,
    required this.total,
    required this.items,
  });

  final int id;
  final String tableName;
  final String status;
  final String invoiceNumber;
  final double subtotal;
  final double taxAmount;
  final double serviceCharge;
  final double total;
  final List<SubmittedOrderItem> items;

  factory SubmittedOrder.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    return SubmittedOrder(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tableName: (json['table_name'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      invoiceNumber: (json['invoice_number'] ?? '').toString(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      serviceCharge: (json['service_charge'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      items: rawItems
          .whereType<Map>()
          .map((e) => SubmittedOrderItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class InvoiceModel {
  InvoiceModel({
    required this.invoiceNumber,
    required this.orderId,
    required this.tableName,
    required this.subtotal,
    required this.taxAmount,
    required this.serviceCharge,
    required this.total,
  });

  final String invoiceNumber;
  final int orderId;
  final String tableName;
  final double subtotal;
  final double taxAmount;
  final double serviceCharge;
  final double total;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceNumber: (json['invoice_number'] ?? '').toString(),
      orderId: (json['order_id'] as num?)?.toInt() ?? 0,
      tableName: (json['table_name'] ?? '').toString(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      serviceCharge: (json['service_charge'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );
  }
}
