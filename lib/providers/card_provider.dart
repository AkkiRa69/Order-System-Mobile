import 'package:flutter/cupertino.dart';
import 'package:grocery_store/model/card_model.dart';

class CardProvider extends ChangeNotifier {
  final List<CardModel> _cardList = [
    CardModel(
        name: "Master Card", cardNum: 444455556666, cvv: 7777, expires: 1214),
    CardModel(
        name: "Visa Card", cardNum: 458965781688, cvv: 4658, expires: 2503),
  ];
  List<CardModel> get cardList => _cardList;
  void addCardToList(CardModel card) {
    _cardList.add(card);
    notifyListeners();
  }

  void removeCardFromList(CardModel card) {
    _cardList.remove(card);
    notifyListeners();
  }
}
