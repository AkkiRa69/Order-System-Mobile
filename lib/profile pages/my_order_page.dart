import 'package:flutter/material.dart';
import 'package:grocery_store/profile pages/order_detail_page.dart';
import 'package:grocery_store/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<OrderProvider>().fetchAllOrders(),
        child: Builder(
          builder: (_) {
            if (orderProvider.isLoading && orderProvider.remoteOrders.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (orderProvider.errorMessage != null &&
                orderProvider.remoteOrders.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        orderProvider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<OrderProvider>().fetchAllOrders(),
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              );
            }
            if (orderProvider.remoteOrders.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 140),
                  Center(child: Text('No orders found')),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: orderProvider.remoteOrders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.remoteOrders[index];
                final createdLabel = order.createdAt == null
                    ? '-'
                    : DateFormat('yyyy/MM/dd HH:mm').format(order.createdAt!);

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(order: order),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3D9D5C)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                order.status.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF3D9D5C),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _row('Table', order.tableName),
                        _row('Items', order.items.length.toString()),
                        _row('Total', '\$${order.total.toStringAsFixed(2)}'),
                        _row('Time', createdLabel),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF737881)),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
