import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/constant/appcolor.dart';
import 'package:grocery_store/model/comment_model.dart';
import 'package:grocery_store/model/randomuser_model.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/pages/write_review_page.dart';
import 'package:grocery_store/providers/comment_provider.dart';
import 'package:grocery_store/providers/randomuser_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  String generateRandomDuration() {
    final random = Random();
    // Randomly decide if the duration will be in minutes, hours, or days
    int choice = random.nextInt(3); // 0 for minutes, 1 for hours, 2 for days

    switch (choice) {
      case 0:
        // Generate random minutes between 1 and 59
        int minutes = random.nextInt(59) + 1;
        return '$minutes minute${minutes > 1 ? 's' : ''} ago';
      case 1:
        // Generate random hours between 1 and 23
        int hours = random.nextInt(23) + 1;
        return '$hours hour${hours > 1 ? 's' : ''} ago';
      case 2:
        // Generate random days between 1 and 7
        int days = random.nextInt(7) + 1;
        return '$days day${days > 1 ? 's' : ''} ago';
      default:
        return '';
    }
  }

  String generateRandomComment() {
    final random = Random();

    // List of good comments
    List<String> goodComments = [
      "Great selection of fresh produce! The fruits and vegetables are always vibrant and well-stocked.",
      "Friendly staff and excellent customer service. They are always ready to help with a smile.",
      "Clean and well-organized store. It makes shopping a breeze every time I visit.",
      "Competitive prices and great deals. I always find what I need at affordable prices.",
      "Convenient location with plenty of parking. I never have trouble finding a spot.",
      "High-quality products and a wide variety of brands. There's something for everyone.",
      "Love the bakery section – always fresh and delicious! The bread and pastries are to die for.",
      "The store layout makes it easy to find what I need. Everything is logically arranged.",
      "Helpful staff who go above and beyond. They make shopping here a pleasant experience.",
      "Fast checkout and efficient service. I never have to wait long in line."
    ];

    // List of bad comments
    List<String> badComments = [
      "Limited selection of fresh produce. The fruits and vegetables are often not fresh.",
      "Rude staff and poor customer service. It's frustrating to shop here sometimes.",
      "The store is often dirty and disorganized. It's hard to find what I'm looking for.",
      "Prices are too high compared to other stores. I feel like I'm overpaying.",
      "Inconvenient location with limited parking. It's always a hassle to park.",
      "Low-quality products and limited brand variety. I struggle to find what I need.",
      "The bakery section is often out of stock. I rarely find fresh bread or pastries.",
      "The store layout is confusing and hard to navigate. I get lost trying to find items.",
      "Unhelpful staff who don't seem to care. Customer service is severely lacking.",
      "Long checkout lines and slow service. It takes forever to get through the line."
    ];

    // Randomly choose between good and bad comment
    bool isGoodComment = random.nextBool();

    if (isGoodComment) {
      // Return a random good comment
      return goodComments[random.nextInt(goodComments.length)];
    } else {
      // Return a random bad comment
      return badComments[random.nextInt(badComments.length)];
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<RandomuserProvider>().read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.appBarColor,
      centerTitle: true,
      title: const Text("Reviews"),
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: const ControllerPage(),
                  type: PageTransitionType.leftToRight));
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: WriteReviewPage(),
                    type: PageTransitionType.bottomToTop));
          },
          icon: const Icon(
            CupertinoIcons.add_circled,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    RandomUserModel randomUserModel =
        context.watch<RandomuserProvider>().randomUserModel;
    List<CommentModel> commentList =
        context.watch<CommentProvider>().commentList;

    return _buildListView(randomUserModel.results, commentList, context);
    // return _buildCommentListView(commentList, context);
  }

  Widget _buildCommentListView(List<CommentModel> items, BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildCommentItem(items[index]);
        },
      ),
    );
  }

  Widget _buildListView(
      List<Result> items, List<CommentModel> coms, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RefreshIndicator(
        color: AppColor.textColor,
        backgroundColor: AppColor.appBarColor,
        onRefresh: () async {
          context.read<RandomuserProvider>().read();
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: coms.length + items.length,
          itemBuilder: (context, index) {
            if (index < coms.length) {
              // Display comment items first
              return _buildCommentItem(coms[index]);
            } else {
              // Display the remaining items
              return _buildItem(items[index - coms.length]);
            }
          },
        ),
      ),
    );
  }

  Widget _buildItem(Result item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.appBarColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 17, right: 17, top: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(item.picture.medium),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.name.first} ${item.name.last}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    generateRandomDuration(),
                    style: TextStyle(
                      color: AppColor.textColor,
                    ),
                  )
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: Color(0xffEBEBEB),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("4.5"),
              const SizedBox(
                width: 5,
              ),
              for (int i = 0; i < 4; i++)
                const Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.amber,
                  size: 18,
                ),
              const Icon(
                CupertinoIcons.star_lefthalf_fill,
                color: Colors.amber,
                size: 18,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            generateRandomComment(),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColor.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(CommentModel item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.appBarColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 17, right: 17, top: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(item.pic),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.firstName} ${item.lastName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    generateRandomDuration(),
                    style: TextStyle(
                      color: AppColor.textColor,
                    ),
                  )
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: Color(0xffEBEBEB),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${item.rate}"),
              const SizedBox(
                width: 5,
              ),
              for (int i = 0; i < item.rate; i++)
                const Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.amber,
                  size: 18,
                ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            item.comment,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColor.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
