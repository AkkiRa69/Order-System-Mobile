import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_image.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/table_order_invoice_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:grocery_store/providers/table_order_provider.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TableOrderCheckoutPage extends StatefulWidget {
  const TableOrderCheckoutPage({super.key});

  @override
  State<TableOrderCheckoutPage> createState() => _TableOrderCheckoutPageState();
}

class _TableOrderCheckoutPageState extends State<TableOrderCheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<FruitProvider>().shoppingCart;
    final orderedItems = cart.where((item) => item.qty > 0).toList();
    final subtotal = context.watch<FruitProvider>().totalPrice(orderedItems);
    final totalQty = orderedItems.fold<int>(0, (acc, item) => acc + item.qty);
    final orderProvider = context.watch<TableOrderProvider>();
    final tableLabel = orderProvider.tableName?.trim().isNotEmpty == true
        ? orderProvider.tableName!
        : orderProvider.tableCode;
    final total = subtotal * 1.15;
    final rielEstimate = total * 4000;
    final previewOrderNo = DateTime.now().millisecondsSinceEpoch.toString();
    final previewTime =
        DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDF2),
        centerTitle: true,
        title: const Text('Order Details'),
      ),
      body: SafeArea(
        child: orderedItems.isEmpty
            ? const Center(child: Text('Your order is empty'))
            : ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Table: $tableLabel',
                              style: const TextStyle(
                                color: Color(0xFF3D9D5C),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Dine-in',
                              style: TextStyle(
                                color: Color(0xFF3D9D5C),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...orderedItems.map(_itemRow),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Total Qty $totalQty',
                            style: const TextStyle(
                              color: Color(0xFF64676E),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(
                          color: Color(0xFFE2E3E7),
                          height: 20,
                        ),
                        _summaryRow(
                            'Subtotal (${orderedItems.length} item)', subtotal),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Coupon',
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              'No Coupon Available',
                              style: TextStyle(
                                color: Color(0xFF9A9CA2),
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color(0xFFE2E3E7),
                          height: 28,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: Color(0xFF6C6E73),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: '\$${total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF3D9D5C),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' \u2248 ${rielEstimate.toStringAsFixed(0)} riel',
                                    style: const TextStyle(
                                      color: Color(0xFF9A9CA2),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _metaRow('Order No.', previewOrderNo),
                        const SizedBox(height: 10),
                        _metaRow('Order Time', previewTime),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (orderProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        orderProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF3D9D5C)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Order More',
                            style: TextStyle(
                              color: Color(0xFF3D9D5C),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: orderProvider.isSubmitting
                              ? null
                              : () async {
                                  final tableProvider =
                                      context.read<TableOrderProvider>();
                                  if (tableProvider.tableCode.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please scan a valid table QR first.',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }

                                  debugPrint(
                                    '[ORDER][SUBMIT] tableCode=${tableProvider.tableCode} '
                                    'itemCount=${orderedItems.length}',
                                  );
                                  final ok = await tableProvider.submitCartOrder(
                                    cartItems: orderedItems,
                                  );
                                  if (!context.mounted) return;
                                  if (!ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          tableProvider.errorMessage ??
                                              'Failed to submit order.',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<FruitProvider>().clearCart();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: const TableOrderInvoicePage(),
                                      type: PageTransitionType.rightToLeft,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D9D5C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            orderProvider.isSubmitting
                                ? 'Submitting...'
                                : 'Submit',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _itemRow(FruitModel item) {
    final lineTotal = item.price * item.qty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 76,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AppImage(path: item.image, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                child: Text(
                  'x ${item.qty}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3F4146),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${lineTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F3136),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.edit_outlined, color: Color(0xFF3D9D5C), size: 20),
              SizedBox(width: 8),
              Text(
                'Remarks: None',
                style: TextStyle(
                  color: Color(0xFF8F9197),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isBold = false}) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: 17,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF3A3C42),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF3A3C42),
          ),
        ),
      ],
    );
  }
}
