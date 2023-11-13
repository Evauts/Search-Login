import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart'; // Custom colors for the app
import '../Login/register.dart'; // Register screen import
import '../Widgets/widgets.dart'; // Reusable widgets import
import '../main.dart'; // Main app file import
import 'package:search/Home/HomeScreen.dart'; // Home screen import

// LoginScreen widget defined as a StatefulWidget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// State class for LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  // Text editing controllers for username and password input fields
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the login screen
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Background gradient decoration for the login screen
          gradient: LinearGradient(
            colors: [
              hexToColor("#46769B"),
              hexToColor("#2F5F8A"),
              hexToColor("#174978"),
              hexToColor("#003366"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: <Widget>[
            // Logo display with padding
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                "assets/images/car-logo.png",
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            // Reusable text field for username input
            reusableTextField("Username or Email Address", Icons.person_outline, false, username),
            const SizedBox(height: 20),
            // Reusable text field for password input
            reusableTextField("Password", Icons.lock_outline, true, password),
            const SizedBox(height: 25),
            // Sign in button with functionality
            signButton(context, true, () {
              // Sign in process with Firebase Authentication
              try {
                final credential = FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: username.text,
                  password: password.text,
                ).then((value) {
                  print("Login Successful!");
                  // Navigate to the HomeScreen upon successful login
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
              // Navigate back to the main app screen regardless of the login result
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ParkerApp()));
            }),
            // Call to action for registration
            buttonFunction()
          ],
        ),
      ),
    );
  }

  // Widget for the registration button with a redirect to the RegisterScreen
  Row buttonFunction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w400, fontFamily: "Times New Roman")),
        GestureDetector(
            onTap: () {
              // Navigation to the RegisterScreen on tap
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
            },
            child: const Text(
              " Click to Register",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Times New Roman"),
            )
        )
      ],
    );
  }
}
