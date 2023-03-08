import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchful/services/auth/auth_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late final User user;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(user.displayName!),
          accountEmail: Text(user.email!),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL!),
          ),
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: NetworkImage(
                  "https://i.pinimg.com/564x/a0/dc/c0/a0dcc01466a29652cbd574f5f6151b28.jpg",
                ),
                fit: BoxFit.cover,
                opacity: 0.65),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.home,
          ),
          title: const Text("Home"),
          dense: true,
          onTap: () {},
        ),
        const Divider(
          color: Colors.grey,
        ),
        ListTile(
          leading: const Icon(
            Icons.account_box,
          ),
          title: const Text("About Us"),
          dense: true,
          onTap: () {},
        ),
        const Divider(
          color: Colors.grey,
        ),
        ListTile(
          leading: const Icon(
            Icons.contact_mail,
          ),
          title: const Text("Contacts"),
          dense: true,
          onTap: () {},
        ),
        const Divider(
          color: Colors.grey,
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Log Out'),
              onTap: () {
                showLogOutDialog(context).then(
                    (value) async => value ? await AuthService().logOut() : "");
              },
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out"))
          ],
        );
      }).then((value) => value ?? false);
}
