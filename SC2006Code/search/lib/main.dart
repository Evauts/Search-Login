// Import necessary Flutter and Firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:search/firebase_options.dart'; // Assuming this is a custom configuration file for Firebase
import 'Login/login.dart';
import 'Search/search.dart';
import 'Home/HomeScreen.dart';

// Main entry point of the Flutter application
void main() async {
  // Ensures that widget binding is initialized before running the app
  // This is necessary for interacting with the Flutter engine
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for the application
  // DefaultFirebaseOptions.currentPlatform is used to ensure compatibility across multiple platforms
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Runs the main ParkerApp widget
  runApp(const ParkerApp());
}

// Root widget of the application
class ParkerApp extends StatelessWidget {
  // Constructor with an optional key parameter
  const ParkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp is the root widget of the app and it includes routes and theme data
    return MaterialApp(
      title: 'ParkerApp', // Title of the application
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Defines a primary color swatch for the app
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adapts the visual density to the platform
      ),
      initialRoute: '/', // The initial route when the app loads
      routes: {
        // Defines the routes and their corresponding widgets in the application
        '/': (context) => const LoginScreen(),      // Route for the Login screen
        '/home': (context) => const HomeScreen(),   // Route for the Home screen
        '/search': (context) => const MySearchPage(), // Route for the Search page
      },
    );
  }
}
