// Update your TextEditingController for the name field
import 'package:flutter/material.dart';

TextEditingController nameController = TextEditingController();

// Wrap your Text widget that displays the name in a Stateful Widget
class CardNumDisplayWidget extends StatefulWidget {
  final TextEditingController controller;

  const CardNumDisplayWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  _CardNumDisplayWidgetState createState() => _CardNumDisplayWidgetState();
}

class _CardNumDisplayWidgetState extends State<CardNumDisplayWidget> {
  String displayedName = 'XXXX XXXX XXXX';
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    // Listen to changes in the text field controller
    widget.controller.addListener(_updateName);
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is disposed
    widget.controller.removeListener(_updateName);
    super.dispose();
  }

  // Update the displayed name whenever the text changes
  void _updateName() {
    setState(() {
      String input = widget.controller.text
          .replaceAll(RegExp(r'\D'), ''); // Remove non-numeric characters
      if (input.length > 12) {
        // Limit to 12 digits
        input = input.substring(0, 12);
      }
      // Insert space every 4 digits
      displayedName = input.replaceAllMapped(
          RegExp(r'.{4}'), (match) => '${match.group(0)} ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedName,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
