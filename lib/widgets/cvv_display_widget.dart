// Update your TextEditingController for the name field
import 'package:flutter/material.dart';

TextEditingController nameController = TextEditingController();

// Wrap your Text widget that displays the name in a Stateful Widget
class CvvDisplayWidget extends StatefulWidget {
  final TextEditingController controller;

  const CvvDisplayWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  _CvvDisplayWidgetState createState() => _CvvDisplayWidgetState();
}

class _CvvDisplayWidgetState extends State<CvvDisplayWidget> {
  String displayedName = '';

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
      if (input.length > 4) {
        // Limit to 4 digits
        input = input.substring(0, 4);
      }
      // Placeholder text
      String placeholder = 'XXXX';
      // Check if the input is empty
      displayedName = input.isEmpty ? placeholder : input;
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

// Inside your _buildBody method, replace the Text widget with the NameDisplayWidget
