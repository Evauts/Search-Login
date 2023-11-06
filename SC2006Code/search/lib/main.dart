import 'package:flutter/material.dart';
import 'search.dart';

void main() {
  runApp(ParkerApp());
}

class ParkerApp extends StatelessWidget {
  //Main Root of application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkerApp',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MySearchPage(),
    );
  }
}