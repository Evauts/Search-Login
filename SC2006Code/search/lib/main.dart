import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'FeedBack/FeedbackScreen.dart';
import 'Login/login.dart';
import 'Search/search.dart';
import 'Home/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => MySearchPage(),
        '/feedback': (context) => FeedbackScreen(),
      },
    );
  }
}
