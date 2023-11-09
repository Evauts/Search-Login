import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Screen!'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/search'),
              child: Text('Go to Search'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/feedback'),
              child: Text('Give Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
