import 'package:animate_do/animate_do.dart';
import 'package:watchful/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  final Duration duration = const Duration(milliseconds: 800);
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FadeInUp(
            duration: duration,
            delay: const Duration(milliseconds: 2000),
            child: Container(
              margin: const EdgeInsets.only(
                top: 50,
                left: 5,
                right: 5,
              ),
              width: size.width,
              height: size.height / 2,
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          FadeInUp(
            duration: duration,
            delay: const Duration(milliseconds: 1600),
            child: const Text(
              "Watchful",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FadeInUp(
            duration: duration,
            delay: const Duration(milliseconds: 1000),
            child: const Text(
              "An incident reporting app that watches for you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.2,
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          FadeInUp(
            duration: duration,
            delay: const Duration(milliseconds: 600),
            child: ElevatedButton(
              onPressed: () {
                AuthService().signInWithGoogle().then((credential) {
                  if (credential.user!.phoneNumber != null) {
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
                backgroundColor: Colors.black, // <-- Buttson color
              ),
              child: Image.asset(
                "assets/images/google_icon.png",
                width: 25,
                height: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    ));
  }
}
