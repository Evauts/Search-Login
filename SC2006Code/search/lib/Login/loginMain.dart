import 'package:flutter/material.dart';
import 'package:search/Login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Main Root of application

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkerApp',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}
