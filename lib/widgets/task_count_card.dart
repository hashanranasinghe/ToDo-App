import 'package:flutter/material.dart';

class TaskCountCard extends StatelessWidget {
  final String text;
  const TaskCountCard({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.21)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ));
  }
}
