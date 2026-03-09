// Update your TextEditingController for the name field
import 'package:flutter/material.dart';

TextEditingController nameController = TextEditingController();

// Wrap your Text widget that displays the name in a Stateful Widget
class NameDisplayWidget extends StatefulWidget {
  final TextEditingController controller;

  const NameDisplayWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  _NameDisplayWidgetState createState() => _NameDisplayWidgetState();
}

class _NameDisplayWidgetState extends State<NameDisplayWidget> {
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
      String input = widget.controller.text;
      // Placeholder text
      String placeholder = 'San Monyakkhara';
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
