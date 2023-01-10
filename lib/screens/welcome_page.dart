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
            "assets/images/phone_auth_img.png",
            width: 150,
            height: 150,
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            "Watchful",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "An incident reporting app.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              AuthService().signInWithGoogle().then((credential) {
                if (credential.user!.phoneNumber != "") {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamed(context, "phoneAuth");
                }
              });
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              elevation: 5,
              backgroundColor: Colors.white, // <-- Buttson color
              foregroundColor: Colors.grey, // <-- Splash color
            ),
            child: Image.asset(
              "assets/images/google_icon.png",
              width: 25,
              height: 25,
            ),
          )
        ],
      ),
    ));
  }
}
