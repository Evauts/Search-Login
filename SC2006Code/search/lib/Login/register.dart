import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search/Login/colors.dart';
import 'package:search/Login/loginMain.dart';
import 'package:search/Login/nextPage.dart';
import 'package:search/Widgets/widgets.dart';
import 'package:search/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Register",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexToColor("#003366"),
            hexToColor("#174978"),
            hexToColor("#2F5F8A"),
            hexToColor("#46769B"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Username (Nickname)", Icons.person_outline,
                    false, username),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Valid Email Address", Icons.person_outline, false, email),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Password (8 - 32 characters)",
                    Icons.lock_outlined, true, password),
                const SizedBox(
                  height: 20,
                ),
                signButton(context, false, () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email.text, password: password.text)
                      .then((value) {
                    print("Login Successful!");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error: ${error.toString()}");
                  });
                })
              ],
            ),
          ))),
    );
  }
}
