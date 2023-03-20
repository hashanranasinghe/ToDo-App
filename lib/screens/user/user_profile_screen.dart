import 'package:flutter/material.dart';
import 'package:todo_app/services/auth/signin_mannager.dart';
import 'package:todo_app/widgets/button_field.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: ButtonField(onpress: (){
          SignInManager().signOut();
        },text: "Sign Out",),
      ),
    );
  }
}
