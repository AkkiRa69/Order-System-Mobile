import 'package:flutter/material.dart';
import 'package:grocery_store/components/dimissible_tile.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/pages/controller_page.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    List<FruitModel> fruits = context.watch<FruitProvider>().favList;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(fruits),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: ControllerPage(
                     
                    ),
                    type: PageTransitionType.leftToRight));
          
        },
        icon: Icon(Icons.arrow_back),
      ),
      backgroundColor: Color(0xffFFFFFF),
      title: Text("Favorites"),
      centerTitle: true,
    );
  }

  Widget _buildBody(List<FruitModel> fruits) {
    return Container(
      color: Color(0xFFF4F5F9),
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          return DimissibleTile(
            fruit: fruits[index],
            isFav: true,
            increment: () {
              setState(() {
                fruits[index].qty++;
              });
            },
            decrement: () {
              setState(() {
                if (fruits[index].qty <= 0) {
                  return;
                }
                fruits[index].qty--;
              });
            },
          );
        },
      ),
    );
  }
}
