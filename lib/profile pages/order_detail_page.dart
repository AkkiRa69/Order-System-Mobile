import 'package:flutter/material.dart';
import 'package:grocery_store/model/table_order_model.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.order});

  final SubmittedOrder order;

  @override
  Widget build(BuildContext context) {
    final createdAt = order.createdAt == null
        ? '-'
        : DateFormat('yyyy/MM/dd HH:mm:ss').format(order.createdAt!);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: Text('Order #${order.id}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _row('Status', order.status.toUpperCase()),
                _row('Table', order.tableName),
                _row('Invoice', order.invoiceNumber),
                _row('Time', createdAt),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('${item.productName} x${item.quantity}'),
                        ),
                        Text(
                          '\$${item.lineTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 22),
                _row('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
                _row('Tax', '\$${order.taxAmount.toStringAsFixed(2)}'),
                _row('Service', '\$${order.serviceCharge.toStringAsFixed(2)}'),
                const Divider(height: 22),
                _row(
                  'Total',
                  '\$${order.total.toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6F7480)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              fontSize: isBold ? 18 : 15,
              color: isBold ? const Color(0xFF3D9D5C) : null,
            ),
          ),
        ],
      ),
    );
  }
}
