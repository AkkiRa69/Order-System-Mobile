import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/model/comment_model.dart';
import 'package:grocery_store/model/randomuser_model.dart';
import 'package:grocery_store/pages/review_page.dart';
import 'package:grocery_store/providers/comment_provider.dart';
import 'package:grocery_store/providers/randomuser_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class WriteReviewPage extends HookWidget {
  WriteReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rating = useState(3);
    final focusNode = useFocusNode();

    void dismissKeyboard() {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    }

    return GestureDetector(
      onTap: dismissKeyboard, // Dismiss keyboard when tapping outside
      child: Scaffold(
        backgroundColor: AppColor.bodyColor,
        appBar: _buildAppBar(),
        body: _buildBody(context, rating, focusNode),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.appBarColor,
      centerTitle: true,
      title: const Text("Write Reviews"),
    );
  }

  final TextEditingController _comment = TextEditingController();

  Widget _buildBody(
      BuildContext context, ValueNotifier<int> rating, FocusNode focusNode) {
    RandomUserModel randomUserModel =
        context.watch<RandomuserProvider>().randomUserModel;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "What do you think?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 55, vertical: 20),
          child: Text(
            "Please give your rating by clicking on the stars below",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff868889),
            ),
          ),
        ),
        StarRating(
          initialRating: rating.value,
          onRatingChanged: (newRating) {
            rating.value = newRating;
          },
          starSize: 40, // Adjust star size if needed
          starSpacing: 8, // Adjust spacing between stars
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          margin: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColor.appBarColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _comment,
            focusNode: focusNode,
            style: const TextStyle(fontSize: 18),
            maxLines:
                null, // Set maxLines to null or more than 1 for multiline input
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              label: Row(
                children: [
                  Icon(
                    CupertinoIcons.pencil,
                    color: AppColor.textColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Tell Mr.Akkhara about your experience",
                    style: TextStyle(
                      color: AppColor.textColor,
                    ),
                  ),
                ],
              ),
              labelStyle: TextStyle(color: AppColor.textColor),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: LinearButton(
                  text: "Comment",
                  onPressed: () {
                    List<Result> items = randomUserModel.results;
                    int randomNum = Random().nextInt(items.length);
                    CommentModel com = CommentModel(
                        comment: _comment.text,
                        firstName: items[randomNum].name.first,
                        lastName: items[randomNum].name.last,
                        pic: items[randomNum].picture.medium,
                        rate: rating.value);
                    context.read<CommentProvider>().addComment(com);
                    Navigator.push(
                        context,
                        PageTransition(
                            isIos: true,
                            duration: const Duration(milliseconds: 300),
                            child: const ReviewPage(),
                            type: PageTransitionType.leftToRight));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StarRating extends HookWidget {
  final int initialRating;
  final Function(int) onRatingChanged;
  final int starCount;
  final double starSize;
  final double starSpacing;

  const StarRating({
    Key? key,
    this.initialRating = 3,
    required this.onRatingChanged,
    this.starCount = 5,
    this.starSize = 50,
    this.starSpacing = 10, // Default spacing between stars
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rating = useState(initialRating);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(starCount, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: starSpacing / 2),
          child: GestureDetector(
            onTap: () {
              rating.value = index + 1;
              onRatingChanged(rating.value);
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                CupertinoIcons.star_fill,
                key: ValueKey<int>(index < rating.value ? 1 : 0),
                color:
                    index < rating.value ? Colors.amber : AppColor.appBarColor,
                size: starSize,
              ),
            ),
          ),
        );
      }),
    );
  }
}
