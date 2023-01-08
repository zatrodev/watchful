import 'package:watchful/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/img1.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Watchful",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "An incident reporting app.",
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          SignInButton(
            Buttons.Google,
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            onPressed: () {
              AuthService().signInWithGoogle(context, () {
                Navigator.pushNamed(context, "phoneAuth");
              });
            },
          )
        ],
      ),
    ));
  }
}
