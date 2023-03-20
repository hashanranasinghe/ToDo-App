import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/screens/login%20&%20register/login_screen.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/widgets/button_field.dart';

class VerificationEmailScreen extends StatefulWidget {
  const VerificationEmailScreen({Key? key}) : super(key: key);
  static const routeName = 'verification email';

  @override
  State<VerificationEmailScreen> createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  Timer? timer;
  bool isEmailVerify = false;
  bool canResendEmail = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerify) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => checkEmailVerify(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  Future checkEmailVerify() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerify) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Please check your emails or Enter your details again.');
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerify
      ? LoginScreen()
      : Scaffold(
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "A verification email has sent to your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Please verify",
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryButtonColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ButtonField(
                    pright: 50,
                    pleft: 50,
                    onpress: () {
                      if (canResendEmail) {
                        sendVerificationEmail();
                      }
                    },
                    text: "Resend Email",
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ButtonField(
                    onpress: () {
                      FirebaseAuth.instance.signOut();
                      openRegister(context);
                    },
                    text: "Cancel",
                    color: Colors.transparent,
                  )
                ]),
          ),
        );
}
