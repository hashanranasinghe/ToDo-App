import 'package:flutter/material.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/button_field.dart';

class TaskDeleteDialog extends StatefulWidget {
  final String title;
  final Function function;
  const TaskDeleteDialog(
      {Key? key, required this.title, required this.function})
      : super(key: key);

  @override
  State<TaskDeleteDialog> createState() => _TaskDeleteDialogState();
}

class _TaskDeleteDialogState extends State<TaskDeleteDialog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Delete Task",
                    style: TextStyle(fontSize: 15),
                  )),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Are You sure you want to delete this task?",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Task title: ${widget.title}",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style:
                            TextStyle(color: kPrimaryButtonColor, fontSize: 20),
                      )),
                  ButtonField(
                    onpress: () {
                      widget.function();
                    },
                    text: "Delete",
                    pright: screenWidth * 0.15,
                    pleft: screenWidth * 0.15,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
