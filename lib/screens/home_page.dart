import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Container(
        margin: const EdgeInsets.all(25),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(user.displayName!),
            Image(image: NetworkImage(user.photoURL!))
          ],
        ),
      ),
    );
  }
}
