import 'package:flutter/material.dart';
import 'package:grocery_store/model/comment_model.dart';

class CommentProvider extends ChangeNotifier {
  final List<CommentModel> _commentList = [];
  List<CommentModel> get commentList => _commentList;

  void addComment(CommentModel item) {
    _commentList.add(item);
    notifyListeners();
  }
}
