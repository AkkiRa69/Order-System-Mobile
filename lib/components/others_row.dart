import 'package:flutter/material.dart';

class OthersRow extends StatelessWidget {
  final IconData icon;
  final Widget verifyIcon;
  final String text;
  const OthersRow(
      {super.key,
      required this.icon,
      required this.text,
      required this.verifyIcon});
  final Color color = const Color(0xff868889);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(
                width: 17,
              ),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          verifyIcon,
        ],
      ),
    );
  }
}
