import 'package:flutter/material.dart';
import 'search.dart';

void main() {
  runApp(const ParkerApp());
}

class ParkerApp extends StatelessWidget {
  const ParkerApp({super.key});

  //Main Root of application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkerApp',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MySearchPage(),
    );
  }
}
