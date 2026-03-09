import 'package:flutter/material.dart';
import 'package:grocery_store/model/card_model.dart';

class CardTile extends StatelessWidget {
  final CardModel card;
  final String icon;
  final int index;
  const CardTile({
    super.key,
    required this.icon,
    required this.card,
    required this.index,
  });

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
                decoration: const BoxDecoration(
                  color: Color(0xffF5F5F5),
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
                    index % 2 == 0 ? "Master Card" : "Visa Card",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      "${insertSpacesAfterFourDigits(card.cardNum)} ${card.cvv}",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xff868889),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expiry: ${insertSlashAfterTwoDigits(card.expires)}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "CVV: ${card.cvv} ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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

  String insertSpacesAfterFourDigits(int input) {
    final String inputString = input.toString();
    const int chunkSize = 4;
    final List<String> chunks = <String>[];

    for (int i = 0; i < inputString.length; i += chunkSize) {
      final int endIndex = (i + chunkSize <= inputString.length)
          ? i + chunkSize
          : inputString.length;
      chunks.add(inputString.substring(i, endIndex));
    }

    return chunks.join(' ');
  }

  String insertSlashAfterTwoDigits(int input) {
    final String inputString = input.toString();
    const int chunkSize = 2;
    final List<String> chunks = <String>[];

    for (int i = 0; i < inputString.length; i += chunkSize) {
      final int endIndex = (i + chunkSize <= inputString.length)
          ? i + chunkSize
          : inputString.length;
      chunks.add(inputString.substring(i, endIndex));
    }

    return chunks.join('/');
  }
}
