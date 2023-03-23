import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/services/auth/signin_mannager.dart';
import 'package:todo_app/services/validator/validate_handeler.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  TextFieldWidget(
                      label: "Email",
                      onchange: (value) {},
                      valid: (value) {
                        return Validator.emailValid(value!);
                      },
                      save: (value) {},
                      controller: emailController),
                  PasswordTextFiled(
                      controller: passwordController,
                      onchange: (value) {},
                      save: (value) {},
                      valid: (value) {
                        return Validator.signupPasswordValid(value!);
                      },
                      label: "Password"),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonField(
                        onpress: () {
                          _signIn();
                        },
                        text: "Login",
                        pright: screenWidth * 0.38,
                        pleft: screenWidth * 0.38,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account?"),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          openRegister(context);
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _signIn() async {
    if (_form.currentState!.validate()) {
      int r = await SignInManager()
          .signIn(emailController.text, passwordController.text);

      if (r == resOk) {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          openTodoList(context);
        } else {
          Fluttertoast.showToast(msg: 'Please verify your email.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Wrong email or password');
      }
    }
  }
}
