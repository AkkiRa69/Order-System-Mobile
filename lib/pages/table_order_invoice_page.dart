import 'package:flutter/material.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/providers/table_order_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TableOrderInvoicePage extends StatelessWidget {
  const TableOrderInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<TableOrderProvider>().lastInvoice;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: SafeArea(
        child: invoice == null
            ? const Center(child: Text('Invoice not available.'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Invoice',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Invoice #: ${invoice.invoiceNumber}'),
                        Text('Order ID: ${invoice.orderId}'),
                        Text('Table: ${invoice.tableName}'),
                        const Divider(height: 24),
                        _priceRow('Subtotal', invoice.subtotal),
                        _priceRow('Tax', invoice.taxAmount),
                        _priceRow('Service', invoice.serviceCharge),
                        const Divider(height: 24),
                        _priceRow('Total', invoice.total, isBold: true),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const ControllerPage(),
                                  type: PageTransitionType.leftToRight,
                                ),
                              );
                            },
                            child: const Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isBold = false}) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: isBold ? 16 : 14,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
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
