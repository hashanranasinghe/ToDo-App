import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/services/auth/signin_mannager.dart';
import 'package:todo_app/services/validator/validate_handeler.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                    TextFieldWidget(
                        label: "UserName",
                        onchange: (value) {},
                        valid: (value) {
                          return Validator.generalValid(value!);
                        },
                        save: (value) {},
                        controller: nameController),
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
                    PasswordTextFiled(
                        controller: confirmPasswordController,
                        onchange: (value) {},
                        save: (value) {},
                        valid: (value) {
                          return Validator.signupPasswordValid(value!);
                        },
                        label: "Confirm Password"),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonField(
                          onpress: () {
                            final UserModel user = UserModel(
                                name: nameController.text,
                                email: emailController.text);
                            _register(user);
                          },
                          text: "Register",
                          pright: screenWidth * 0.35,
                          pleft: screenWidth * 0.35,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            openLogin(context);
                          },
                          child: Text(
                            "Login",
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
      ),
    );
  }

  _register(UserModel user) async {
    if (_form.currentState!.validate()) {
      int r = await SignInManager()
          .signUp(emailController.text, confirmPasswordController.text, user);
      if (r == resOk) {
        openVerification(context);
      } else {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email');
      }

      print(user.name);
    }
  }
}
