import 'package:flutter/material.dart';
import 'package:todo_app/screens/Task/add_category_screen.dart';
import 'package:todo_app/screens/Task/task-screen.dart';
import 'package:todo_app/screens/auth/check_signIn.dart';
import 'package:todo_app/screens/auth/verificationscreen.dart';
import 'package:todo_app/screens/focus/focus_screen.dart';
import 'package:todo_app/screens/intro/welcome_screen.dart';
import 'package:todo_app/screens/login%20&%20register/login_screen.dart';
import 'package:todo_app/screens/login%20&%20register/register_screen.dart';
import 'package:todo_app/screens/user/user_profile_screen.dart';

import 'package:todo_app/widgets/bottom_navigation_bar.dart';

void openHome(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()));
}

void openAddCategory(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(fullscreenDialog: true   ,builder: (context) => AddCategoryScreen()));
}

void openLogin(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => LoginScreen()));
}

void openRegister(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => RegisterScreen()));
}
void openTodoList(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => BottomNavBar()));
}

void openTask(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(fullscreenDialog:true,builder: (context) => TaskScreen()));
}

void openFocus(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => FocusScreen()));
}

void openProfile(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => UserProfileScreen()));
}

void openCheckSignIn(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const CheckSignIn()));
}

void openVerification(BuildContext context) async {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const VerificationEmailScreen()));
}