import 'package:flutter/material.dart';
import 'package:search/Search/search.dart';
import 'package:search/FeedBack/FeedbackScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Screen!'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MySearchPage()));
                },
              child: const Text('Go to Search'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FeedbackScreen()));
              },
              child: const Text('Give Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
