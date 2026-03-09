import 'package:flutter/material.dart';

class AspectChild {
  static int calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 4; // You can adjust this value based on your design
    } else {
      return 2; // You can adjust this value based on your design
    }
  }

  // Calculate the child aspect ratio dynamically based on screen size
  static double calculateAspectRatio(BuildContext context) {
    // You can adjust these values as needed to achieve the desired aspect ratio
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const aspectRatio = 0.65; // Your desired aspect ratio

    // Calculate aspect ratio based on screen width and height
    if (screenWidth < screenHeight) {
      return aspectRatio;
    } else {
      // For landscape orientation, you may want to adjust the aspect ratio
      // based on your design requirements
      return aspectRatio * 1.2; // Example adjustment, you can modify this
    }
  }
}
