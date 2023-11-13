// Importing necessary packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search/Login/colors.dart'; // Custom colors for the app
import 'package:search/Home/HomeScreen.dart'; // Home screen import
import 'package:search/Widgets/widgets.dart'; // Reusable widgets import

// RegisterScreen defined as a StatefulWidget to manage user registration
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}); // Constructor

  @override
  RegisterState createState() => RegisterState(); // Creating state for the widget
}

// State class for RegisterScreen
class RegisterState extends State<RegisterScreen> {
  // Text editing controllers for user input fields
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Scaffold widget provides the structure for the registration screen
    return Scaffold(
      extendBodyBehindAppBar: true, // Extends the body behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // No shadow
        title: const Text(
          "Register", // AppBar title
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            // Gradient background decoration
              gradient: LinearGradient(colors: [
                hexToColor("#003366"),
                hexToColor("#174978"),
                hexToColor("#2F5F8A"),
                hexToColor("#46769B"),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            // Allows scrolling when the content is larger than the screen
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    reusableTextField("Username (Nickname)", Icons.person_outline, false, username),
                    const SizedBox(height: 20),
                    reusableTextField("Valid Email Address", Icons.person_outline, false, email),
                    const SizedBox(height: 20),
                    reusableTextField("Password (8 - 32 characters)", Icons.lock_outlined, true, password),
                    const SizedBox(height: 20),
                    signButton(context, false, () {
                      // Firebase Authentication for user registration
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(email: email.text, password: password.text)
                          .then((value) {
                        print("Registration Successful!");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }).onError((error, stackTrace) {
                        print("Error: ${error.toString()}");
                      });
                    })
                  ],
                ),
              )
          )
      ),
    );
  }
}
