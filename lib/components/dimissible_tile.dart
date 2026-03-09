import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/components/app_image.dart';
import 'package:grocery_store/model/fruit_model.dart';
import 'package:grocery_store/providers/fruit_provider.dart';
import 'package:provider/provider.dart';

class DimissibleTile extends StatefulWidget {
  final bool isFav;
  final FruitModel fruit;
  final Function() increment, decrement;
  const DimissibleTile(
      {super.key,
      this.isFav = false,
      required this.fruit,
      required this.increment,
      required this.decrement});

  @override
  State<DimissibleTile> createState() => _DimissibleTileState();
}

class _DimissibleTileState extends State<DimissibleTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      secondaryBackground: _buildDismissibleRightToLeft(),
      background: _buildDismissibleLeftToRight(),
      onDismissed: (DismissDirection direction) {
        setState(() {
          if (widget.isFav == false) {
            context.read<FruitProvider>().removeProductFromCart(widget.fruit);
          }
          if (widget.isFav == true) {
            context.read<FruitProvider>().removeProductFavorite(widget.fruit);
          }
        });
      },
      key: UniqueKey(),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.symmetric(horizontal: 17, vertical: 6),
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //images + detail
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: 70,
                        width: 70,
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: widget.fruit.color,
                          // borderRadius: BorderRadius.circular(50),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      // left: 5,
                      child: AppImage(path: widget.fruit.image, height: 70),
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$" + widget.fruit.price.toStringAsFixed(2),
                        style: TextStyle(
                          color: Color(0xFF6CC51D),
                        ),
                      ),
                      Text(
                        widget.fruit.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.fruit.weight,
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.increment();
                  },
                  child: Icon(
                    color: Colors.green,
                    CupertinoIcons.add,
                    size: 20,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  child: Text(
                    (widget.fruit.qty).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.decrement();
                  },
                  child: Icon(
                    color: Colors.green,
                    CupertinoIcons.minus,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleRightToLeft() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 30),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 17),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.delete,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDismissibleLeftToRight() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 30),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 17),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.delete,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
