import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //card
            Row(
              children: [
                _buildCard("assets/icons/pay.png", "Paypal"),
                const SizedBox(
                  width: 10,
                ),
                _buildCard("assets/icons/card.png", "Credit card"),
                const SizedBox(
                  width: 10,
                ),
                _buildCard("assets/icons/apple.png", "Apple pay"),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            //credit card
            Image.asset("assets/icons/credit_card.png"),
            const SizedBox(
              height: 15,
            ),
            //textField
            _buildTextField(CupertinoIcons.person, "Name on the card"),
            _buildTextField(CupertinoIcons.creditcard, "Card number"),
            Row(
              children: [
                Expanded(
                    child:
                        _buildTextField(CupertinoIcons.calendar, "Month/Year")),
                const SizedBox(
                  width: 8,
                ),
                Expanded(child: _buildTextField(CupertinoIcons.lock, "CVV")),
              ],
            ),
            const Row(
              children: [
                Icon(
                  Icons.toggle_on_rounded,
                  color: Color(0xFF6CC51D),
                  size: 38,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Save this address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField(IconData icon, String text) {
  return Container(
    decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.all(7),
    margin: const EdgeInsets.only(bottom: 8),
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF969696),
        ),
        hintText: text,
        hintStyle: const TextStyle(color: Color(0xFF969696)),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget _buildCard(String image, String text) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 30,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF868889),
            ),
          ),
        ],
      ),
    ),
  );
}
