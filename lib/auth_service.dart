import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watchful/screens/home_page.dart';
import 'package:watchful/screens/phone_auth.dart';
import 'package:watchful/screens/welcome_page.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const WelcomePage();
          }
        }));
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<PhoneAuthCredential> verifyPhoneNumber(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: PhoneAuth.verificationId, smsCode: smsCode);

    return credential;
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
