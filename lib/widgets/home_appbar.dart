import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.green[800],
      title: const Text(
        "WATCHFUL",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      centerTitle: true,
      leading: SizedBox(
        width: 58,
        child: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: FirebaseAuth.instance.currentUser!.photoURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL!),
                    radius: 15,
                  )
                : const Icon(Icons.account_circle_rounded)),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.search),
        ),
      ],
    );
  }
}
