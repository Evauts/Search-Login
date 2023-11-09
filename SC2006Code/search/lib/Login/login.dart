import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:search/Login/colors.dart';
import 'package:search/Login/nextPage.dart';
import 'package:search/Login/register.dart';
import 'package:search/Widgets/widgets.dart';
import 'package:search/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
            const SizedBox(
              height: 30,
            ),
            reusableTextField("Username or Email Address", Icons.person_outline,
                false, username),
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Password", Icons.lock_outline, true, password),
            const SizedBox(
              height: 25,
            ),
            signButton(context, true, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ParkerApp()));
            }),
            buttonFunction()
          ],
        ),
      ),
    );
  }

  Row buttonFunction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: "Times New Roman")),
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()));
            },
            child: const Text(
              " Click to Register",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Times New Roman"),
            ))
      ],
    );
  }
}
