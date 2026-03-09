import 'package:flutter/material.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/providers/table_order_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TableOrderInvoicePage extends StatelessWidget {
  const TableOrderInvoicePage({super.key});
  static const String _paymentQrAsset = 'assets/images/aba_payment_qr.png';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableOrderProvider>();
    final invoice = provider.lastInvoice;
    final order = provider.lastOrder;

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDEDF2),
        centerTitle: true,
        title: const Text('Invoice'),
      ),
      body: SafeArea(
        child: invoice == null
            ? const Center(child: Text('Invoice not available.'))
            : ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Payment Successful',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D9D5C)
                                    .withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                (order?.status ?? 'paid').toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF3D9D5C),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _infoRow('Invoice No.', invoice.invoiceNumber),
                        _infoRow('Order ID', invoice.orderId.toString()),
                        _infoRow('Table', invoice.tableName),
                        if (order != null)
                          _infoRow('Items', order.items.length.toString()),
                        const SizedBox(height: 8),
                        const Divider(color: Color(0xFFE5E6EA), height: 20),
                        if (order != null) ...[
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...order.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.productName} x${item.quantity}',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Text(
                                    '\$${item.lineTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(color: Color(0xFFE5E6EA), height: 22),
                        ],
                        _priceRow('Subtotal', invoice.subtotal),
                        _priceRow('Tax', invoice.taxAmount),
                        _priceRow('Service', invoice.serviceCharge),
                        const Divider(color: Color(0xFFE5E6EA), height: 22),
                        _priceRow('Total', invoice.total, isBold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Scan To Pay',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            _paymentQrAsset,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 220,
                                alignment: Alignment.center,
                                color: const Color(0xFFF5F6F8),
                                child: const Text(
                                  'Place payment QR at\nassets/images/aba_payment_qr.png',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF7D818A)),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'KHR account: 005 443 053',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'USD account: 005 443 049',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const ControllerPage(),
                                type: PageTransitionType.leftToRight,
                              ),
                            );
                          },
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
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D9D5C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7D818A),
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2E3238),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool isBold = false}) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
      fontSize: isBold ? 23 : 16,
      color: isBold ? const Color(0xFF3D9D5C) : const Color(0xFF2E3238),
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
