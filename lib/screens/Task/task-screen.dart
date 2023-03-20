import 'package:flutter/material.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/Task_priority_widget.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/choose_category_widget.dart';
import 'package:todo_app/widgets/edit_task_dialog.dart';
import 'package:todo_app/widgets/task_button.dart';
import 'package:todo_app/widgets/task_delete_dialog.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _timeOfDay;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Do Math HomeWork",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Do chapter 2 to 5 for next week",
                                style: TextStyle(
                                    color: kPrimaryTextColor, fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return EditTaskDialog(
                                          titleController: titleController,
                                          descriptionController:
                                              descriptionController);
                                    });
                              },
                              icon: Icon(Icons.create_outlined))
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TaskRow(
                      function: () {
                        _getCalendar();
                      },
                      text: "Today",
                      topicIcon: Icons.calendar_month_outlined,
                      topic: "Task Date"),
                  SizedBox(
                    height: 30,
                  ),
                  TaskRow(
                      function: () {
                        _getTime();
                      },
                      text: "16.45",
                      topicIcon: Icons.timer_outlined,
                      topic: "Task Time"),
                  SizedBox(
                    height: 30,
                  ),
                  TaskRow(
                      function: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ChooseCategoryWidget();
                            });
                      },
                      text: "University",
                      btnIcon: Icons.school_outlined,
                      topicIcon: Icons.category_outlined,
                      topic: "Task Category"),
                  SizedBox(
                    height: 30,
                  ),
                  TaskRow(
                      function: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TaskPriorityWidget();
                            });
                      },
                      text: "Default",
                      topicIcon: Icons.flag_outlined,
                      topic: "Task Priority"),
                  SizedBox(
                    height: 30,
                  ),
                  TaskRow(
                      function: () {},
                      text: "Add Sub-Task",
                      topicIcon: Icons.add_task_outlined,
                      topic: "Sub-Task"),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskDeleteDialog(
                                      title: "Do math HomeWork",
                                      function: () {});
                                });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: kPrimaryErrorColor,
                                size: 30,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Delete Task",
                                style: TextStyle(
                                    fontSize: 18, color: kPrimaryErrorColor),
                              )
                            ],
                          )),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  ButtonField(
                    onpress: () {},
                    text: "Edit Task",
                    pleft: screenWidth * 0.3,
                    pright: screenWidth * 0.3,
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          )),
    );
  }

  _getCalendar() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (newDate == null) {
      return;
    }
    setState(() {
      _selectedDate = newDate;
    });
  }
  _getTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }


}
