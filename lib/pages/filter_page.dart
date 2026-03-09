import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/components/filter_text_field.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/components/others_row.dart';
import 'package:grocery_store/constant/appcolor.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(17),
        child: LinearButton(text: "Apply filter", onPressed: () {}),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.appBarColor,
      title: const Text("Apply Filters"),
      centerTitle: true,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.appBarColor,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Price Range",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 17),
                child: Row(
                  children: [
                    Expanded(child: FilterTextField(hintText: "Min.")),
                    SizedBox(width: 7),
                    Expanded(child: FilterTextField(hintText: "Max.")),
                  ],
                ),
              ),
              const Divider(
                color: Color(0xffEBEBEB),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Star Rating",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.bodyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 17),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        Text(
                          "4 stars",
                          style: TextStyle(
                            color: Color(0xff868889),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color(0xffEBEBEB),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Othes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 17),
                child: Column(
                  children: [
                    OthersRow(
                      icon: Icons.discount_outlined,
                      text: "Discount",
                      verifyIcon: Icon(
                        Icons.verified_outlined,
                        color: Color(0xff868889),
                        size: 20,
                      ),
                    ),
                    Divider(
                      color: Color(0xffEBEBEB),
                    ),
                    OthersRow(
                      icon: Icons.fire_truck_outlined,
                      text: "Free shipping",
                      verifyIcon: Icon(
                        Icons.verified_outlined,
                        color: Color(0xff6CC51D),
                        size: 20,
                      ),
                    ),
                    Divider(
                      color: Color(0xffEBEBEB),
                    ),
                    OthersRow(
                      icon: CupertinoIcons.cube_box,
                      text: "Same day delivery",
                      verifyIcon: Icon(
                        Icons.verified_outlined,
                        color: Color(0xff6CC51D),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
