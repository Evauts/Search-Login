// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:search/Login/login.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
