import 'package:flutter/material.dart';
import 'package:grocery_store/components/hoz_timeLine_tile.dart';
import 'package:grocery_store/components/liner_button.dart';
import 'package:grocery_store/pages/order_success.dart';
import 'package:grocery_store/pages/track_order_page.dart';
import 'package:grocery_store/shippingMethodpage/first_page.dart';
import 'package:grocery_store/shippingMethodpage/second_page.dart';
import 'package:grocery_store/shippingMethodpage/third_page.dart';
// Assuming this is your track order page
import 'package:page_transition/page_transition.dart'; // Ensure you have this import for page transitions

class NewShippingMethodPage extends StatefulWidget {
  const NewShippingMethodPage({super.key});

  @override
  State<NewShippingMethodPage> createState() => _NewShippingMethodPageState();
}

class _NewShippingMethodPageState extends State<NewShippingMethodPage> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  List<Widget> pages = [
    const FirstPage(),
    const SecondPage(),
    const ThirdPage(),
  ];

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(17),
      child: Row(
        children: [
          Expanded(
            child: LinearButton(
              text: currentIndex == 2 ? "Make a payment" : "Next",
              onPressed: () {
                if (currentIndex < 2) {
                  setState(() {
                    currentIndex++;
                  });
                  _pageController.animateToPage(
                    currentIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: OrderSuccessPage(
                        appBarTitle: 'Order Success',
                        subtitle:
                            'You will get a response within a few minutes',
                        title: "Your order was successful!",
                        btnText: 'Track order',
                        onPressed: (BuildContext context) {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const TrackOrderPage(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        },
                      ),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F9),
      appBar: AppBar(title: const Text("Shipping Method")),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HozTimeLineTile(
                          isFirst: true,
                          isLast: false,
                          isPast: currentIndex >= 0,
                          index: 1,
                          child: currentIndex > 0
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : Text(
                                  '1',
                                  style: TextStyle(
                                    color: currentIndex >= 0
                                        ? Colors.white
                                        : const Color(0xff868889),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const Text("DELIVERY"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HozTimeLineTile(
                          isFirst: false,
                          isLast: false,
                          isPast: currentIndex >= 1,
                          index: 2,
                          child: currentIndex > 1
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : Text(
                                  '2',
                                  style: TextStyle(
                                    color: currentIndex >= 1
                                        ? Colors.white
                                        : const Color(0xff868889),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const Text("ADDRESS"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HozTimeLineTile(
                          isFirst: false,
                          isLast: true,
                          isPast: currentIndex >= 2,
                          index: 3,
                          child: currentIndex > 2
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : Text(
                                  '3',
                                  style: TextStyle(
                                    color: currentIndex >= 2
                                        ? Colors.white
                                        : const Color(0xff868889),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const Text("PAYMENT"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
            ),
            _buildBottomBar(), // Add the bottom bar here
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
