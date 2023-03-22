import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchful/services/cloud/firebase_cloud_storage.dart';
import 'package:watchful/widgets/custom_snackbar.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  static String verificationId = "";

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  late final TextEditingController _countryCode;
  late final TextEditingController _number;

  @override
  void initState() {
    _countryCode = TextEditingController();
    _countryCode.text = "63";

    _number = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _countryCode.dispose();
    _number.dispose();
    super.dispose();
  }

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
              "Phone Verification",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Register your phone for SMS incident reporting system.",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 55,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("+"),
                  SizedBox(
                    width: 30,
                    child: TextField(
                      controller: _countryCode,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Text(
                    "|",
                    style: TextStyle(fontSize: 33, color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextField(
                    controller: _number,
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Phone",
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    final phoneNumber = "+${_countryCode.text}${_number.text}";

                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        final incidentsService = FirebaseCloudStorage();
                        await incidentsService.addNumber(phoneNumber);
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              CustomSnackBar(errorText: e.message.toString()),
                          backgroundColor: Colors.transparent,
                          behavior: SnackBarBehavior.floating,
                          elevation: 0,
                        ));
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        PhoneAuthPage.verificationId = verificationId;
                        Navigator.pushNamed(context, 'phoneVerify');
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  },
                  child: const Text("Send the code")),
            )
          ],
        ),
      ),
    );
  }
}
