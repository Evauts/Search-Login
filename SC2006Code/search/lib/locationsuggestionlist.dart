import 'package:flutter/material.dart';

class LocationSuggestion extends StatelessWidget {
  const LocationSuggestion({
    Key? key,
    required this.location,
    required this.press,
  }) : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
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
          color: Colors.grey,
          indent: 16.0, // Adjust the left indent of the Divider
          endIndent: 16.0, // Adjust the right indent of the Divider
        )
      ],
    );
  }
}
