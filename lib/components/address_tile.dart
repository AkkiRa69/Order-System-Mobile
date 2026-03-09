import 'package:flutter/material.dart';
import 'package:grocery_store/model/address_model.dart';

class AddressTile extends StatelessWidget {
  final AddressModel add;
  final String icon;
  final Color? color;
  const AddressTile(
      {super.key, required this.add, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(17),
                child: Image.asset(
                  icon,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    add.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      "${add.country}, ${add.address}, ${add.city}",
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff868889),
                      ),
                    ),
                  ),
                  Text(
                    "${add.zipCode} ${add.phone}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            "assets/icons/expand.png",
            height: 20,
          ),
        ],
      ),
    );
  }
}
