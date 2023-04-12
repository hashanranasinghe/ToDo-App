// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/utils/navigation.dart';

import '../../utils/constraints.dart';

class SplashScreen extends StatefulWidget {
  static const routName = 'splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds:3);

    return new Timer(duration, route);
  }

  route() async{
    openCheckSignIn(context);
  }

  initScreen(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: size.width * 0.1,
                      left: size.width * 0.1,
                      right: size.width * 0.1),
                  child: Image.asset(logo,scale: 7,)),
              Text("My ToDo",style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold
              ),),
              Lottie.asset(loadingAnim,width: 50,height: 50),

              SizedBox(
                height: size.height * 0.22,
              ),
              Text(
                "Copyright 2022 © My ToDo ",
                style: TextStyle(

                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ));
  }
}
