import 'package:flutter/foundation.dart';
import 'package:grocery_store/model/randomuser_model.dart';
import 'package:http/http.dart' as http;

class RandomuserProvider extends ChangeNotifier {
  RandomUserModel _randomUserModel = RandomUserModel(
      info: Info(seed: "", page: 0, results: 0, version: ""), results: []);
  RandomUserModel get randomUserModel => _randomUserModel;

  Future<void> read() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=50'));

    if (response.statusCode == 200) {
      _randomUserModel = await compute(randomUserModelFromMap, response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
