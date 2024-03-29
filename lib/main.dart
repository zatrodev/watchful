import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchful/services/auth/auth_service.dart';
import 'package:watchful/firebase_options.dart';
import 'package:watchful/screens/add_incident.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthService().handleAuthState(),
        'phoneAuth': (context) => const PhoneAuthPage(),
        'phoneVerify': (context) => const PhoneVerifyPage(),
        'addIncident': (context) => const AddIncidentPage()
      },
    );
  }
}
