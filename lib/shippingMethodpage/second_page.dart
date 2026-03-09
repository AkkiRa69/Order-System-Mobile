import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(CupertinoIcons.person, "Name"),
            _buildTextField(CupertinoIcons.mail, "Email address"),
            _buildTextField(CupertinoIcons.phone, "Phone number"),
            _buildTextField(CupertinoIcons.map_pin_ellipse, "Address"),
            _buildTextField(CupertinoIcons.keyboard, "Zip code"),
            _buildTextField(CupertinoIcons.map, "City"),
            _buildTextField(CupertinoIcons.location_solid, "Country"),
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
