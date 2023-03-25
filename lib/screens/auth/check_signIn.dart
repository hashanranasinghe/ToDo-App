import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/login%20&%20register/login_screen.dart';
import 'package:todo_app/widgets/bottom_navigation_bar.dart';


class CheckSignIn extends StatelessWidget {
  static const routName = 'check-screen';
  const CheckSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser;
          return BottomNavBar(userId: user!.uid);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something went to wrong!!"),
          );
        } else {
          return const LoginScreen();
        }
      },
    ));
  }
}
