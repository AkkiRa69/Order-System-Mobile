import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildShippingMethod(
                "Standard Delivery",
                "Order will be delivered between 3 - 4 business days straights to your doorstep.",
                3.00),
            _buildShippingMethod(
                "Next Day Delivery",
                "Order will be delivered between 3 - 4 business days straights to your doorstep.",
                5.00),
            _buildShippingMethod(
                "Nominated Delivery",
                "Order will be delivered between 3 - 4 business days straights to your doorstep.",
                3.00),
          ],
        ),
      ),
    );
  }
}

Widget _buildShippingMethod(String title, String subTitle, double price) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
    margin: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                "\$${price.toStringAsFixed(0)}",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Color(0xFF6CC51D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
