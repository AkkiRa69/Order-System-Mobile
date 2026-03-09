import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyBanner extends StatelessWidget {
  MyBanner({super.key});
  final PageController _controller = PageController();
  final List<String> posters = [
    "poster1.jpg",
    "poster3.jpg",
    "poster4.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _controller,
            itemCount: posters.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/images/${posters[index]}",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 40,
          top: 20,
          child: SmoothPageIndicator(
            controller: _controller,
            count: posters.length,
            effect: const WormEffect(
              activeDotColor: Color(0xFF6CC51D),
              dotColor: Colors.white,
              dotHeight: 7,
              dotWidth: 7,
            ),
          ),
        ),
      ],
    );
  }
}
