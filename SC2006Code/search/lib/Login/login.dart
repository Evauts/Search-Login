import 'package:flutter/material.dart';
import 'package:search/Login/colors.dart';
import 'package:search/Widgets/widgets.dart';

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
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            reusableTextField("Username or Email Address", Icons.person_outline, false,
                username),
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Password", Icons.lock_outline, true,
                password),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
