import 'package:flutter/material.dart';

class TaskRow extends StatelessWidget {
  final String text;
  final IconData? btnIcon;
  final IconData topicIcon;
  final String topic;
  final Function function;
  const TaskRow(
      {Key? key,
      required this.text,
      this.btnIcon,
      required this.topicIcon,
      required this.topic,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [Icon(topicIcon),
            SizedBox(
              width: 10,
            ),
            Text("$topic:")],
        ),
        InkWell(
          onTap: (){
            function();
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.21)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    if (btnIcon != null) ...[
                      Icon(btnIcon),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                    Text(
                      text,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
