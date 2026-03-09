// Update your TextEditingController for the name field
import 'package:flutter/material.dart';

TextEditingController nameController = TextEditingController();

// Wrap your Text widget that displays the name in a Stateful Widget
class ExpiresDisplayWidget extends StatefulWidget {
  final TextEditingController controller;

  const ExpiresDisplayWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  _ExpiresDisplayWidgetState createState() => _ExpiresDisplayWidgetState();
}

class _ExpiresDisplayWidgetState extends State<ExpiresDisplayWidget> {
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
        // Limit to 4 characters (MMYY)
        input = input.substring(0, 4);
      }
      if (input.length >= 2) {
        // Insert slash after the first 2 digits
        input = '${input.substring(0, 2)}/${input.substring(2)}';
      }
      // Placeholder text
      String placeholder = 'MM/YY';
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Inside your _buildBody method, replace the Text widget with the NameDisplayWidget
