import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchful/auth_service.dart';
import 'package:watchful/firebase_options.dart';
import 'package:watchful/screens/phone_auth.dart';
import 'package:watchful/screens/phone_verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Watchful());
}

class Watchful extends StatelessWidget {
  const Watchful({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watchful',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthService().handleAuthState(),
        'phoneAuth': (context) => const PhoneAuthPage(),
        'phoneVerify': (context) => const PhoneVerifyPage(),
      },
    );
  }
}
