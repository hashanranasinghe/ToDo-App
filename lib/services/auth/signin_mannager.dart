import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/utils/constraints.dart';

class SignInManager extends ChangeNotifier {
  Future<int> signIn(String email, String password) async {
    int res = resFail;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      res = resOk;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = resFail;
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        res = resFail;
        //print('Wrong password provided for that user.');
      }
    }
    notifyListeners();
    return res;
  }

  Future<int> signUp(String em, String pw, UserModel userModel) async {
    int res = resFail;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: em, password: pw);

      // Send email verification
      await userCredential.user
          ?.sendEmailVerification()
          .then((value) => FbHandler.createDocAuto(userModel.toMap(), "user"));


      res = resOk;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = resFail;
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        res = resFail;
        print('The account already exists for that email.');
      }
    } catch (e) {
      res = resFail;
      print(e);
    }

    notifyListeners();
    return res;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<int> resetPassword({required String email}) async {
    int r = 0;
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => r = 1)
        .catchError((e) => r = 0);

    print(r);
    return r;
  }
}
