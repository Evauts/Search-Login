import 'package:flutter/material.dart';

class LocationSuggestion extends StatelessWidget {
  const LocationSuggestion({
    Key? key,
    required this.location,
    required this.press,
    required this.controller,
  }) : super(key: key);

  final String location;
  final VoidCallback press;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            press();
            controller.text = location;
          },
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Adjust padding
          dense: true, // Reduce the height of the ListTile
          horizontalTitleGap: 0,
          title: Text(
            location,
            style: TextStyle(fontSize: 16.0), // Reduce font size
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          color: Colors.grey, // Adjust the right indent of the Divider
        )
      ],
    );
  }
}
