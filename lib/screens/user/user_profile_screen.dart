import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/auth/signin_mannager.dart';
import 'package:todo_app/view%20models/user%20view%20model/userViewModel.dart';
import 'package:todo_app/widgets/button_field.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, userViewModel, child) {
      if (userViewModel.userModel == null) {
        userViewModel.getCurrentUser(id: user!.uid);
        return const Center(child: CircularProgressIndicator());
      } else {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(userViewModel.userModel!.name.toString()),
            centerTitle: true,
          ),
          body: Center(
            child: ButtonField(
              onpress: () {
                SignInManager().signOut();
              },
              text: "Sign Out",
            ),
          ),
        );
      }
    });
  }
}
