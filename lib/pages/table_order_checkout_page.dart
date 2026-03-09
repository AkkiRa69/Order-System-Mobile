import 'package:flutter/material.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/table_order_invoice_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:grocery_store/providers/table_order_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TableOrderCheckoutPage extends StatefulWidget {
  const TableOrderCheckoutPage({super.key});

  @override
  State<TableOrderCheckoutPage> createState() => _TableOrderCheckoutPageState();
}

class _TableOrderCheckoutPageState extends State<TableOrderCheckoutPage> {
  late final TextEditingController _tableController;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final existingTableCode = context.read<TableOrderProvider>().tableCode;
    _tableController = TextEditingController(text: existingTableCode);
  }

  @override
  void dispose() {
    _tableController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<FruitProvider>().shoppingCart;
    final orderedItems = cart.where((item) => item.qty > 0).toList();
    final subtotal = context.watch<FruitProvider>().totalPrice(orderedItems);
    final orderProvider = context.watch<TableOrderProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Table Order Checkout'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _tableController,
              decoration: const InputDecoration(
                labelText: 'Table QR/Code',
                hintText: 'Paste QR URL or table code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note for kitchen (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (orderedItems.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('No items with quantity > 0.'),
                ),
              ),
            ...orderedItems.map((item) => _itemRow(item)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _summaryRow('Subtotal', subtotal),
                    _summaryRow('Estimated Tax (10%)', subtotal * 0.10),
                    _summaryRow('Estimated Service (5%)', subtotal * 0.05),
                    const Divider(),
                    _summaryRow('Estimated Total', subtotal * 1.15,
                        isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (orderProvider.errorMessage != null)
              Text(
                orderProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            LinearButton(
              text: orderProvider.isSubmitting
                  ? 'Submitting...'
                  : 'Submit Order to POS',
              onPressed: orderProvider.isSubmitting
                  ? () {}
                  : () async {
                      final tableOrderProvider =
                          context.read<TableOrderProvider>();
                      tableOrderProvider.setTableCode(_tableController.text);
                      final ok = await tableOrderProvider.submitCartOrder(
                        cartItems: orderedItems,
                        notes: _noteController.text,
                      );
                      if (!context.mounted) return;
                      if (!ok) return;

                      context.read<FruitProvider>().clearCart();
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const TableOrderInvoicePage(),
                          type: PageTransitionType.rightToLeft,
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemRow(FruitModel item) {
    final lineTotal = item.price * item.qty;
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('Qty: ${item.qty} x \$${item.price.toStringAsFixed(2)}'),
        trailing: Text('\$${lineTotal.toStringAsFixed(2)}'),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isBold = false}) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 16 : 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
