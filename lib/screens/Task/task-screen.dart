import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/view%20models/category%20view%20model/category_list_view_model.dart';
import 'package:todo_app/view%20models/task%20view%20models/add_task_view_model.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/widgets/Task_priority_widget.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/choose_category_widget.dart';
import 'package:todo_app/widgets/edit_task_dialog.dart';
import 'package:todo_app/widgets/task_button.dart';
import 'package:todo_app/widgets/task_delete_dialog.dart';

class TaskScreen extends StatefulWidget {
  final TaskModel taskModel;
  const TaskScreen({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late AddTaskViewModel addTaskViewModel;
  late TaskListViewModel taskListViewModel;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late DateTime _selectedDate;
  late TimeOfDay _timeOfDay;


  @override
  void initState() {
    super.initState();
    titleController.text = widget.taskModel.title;
    descriptionController.text = widget.taskModel.description;
    _selectedDate = widget.taskModel.date;
    _timeOfDay =
        Convert.convertTime(time: Convert.getTime(time: widget.taskModel.time));
    _populateCategories();
  }

  _populateCategories() {
    addTaskViewModel = Provider.of<AddTaskViewModel>(context, listen: false);
    addTaskViewModel.priority = widget.taskModel.priority;
    addTaskViewModel.category = widget.taskModel.category;
    addTaskViewModel.title = widget.taskModel.title;
    addTaskViewModel.description = widget.taskModel.description;
    taskListViewModel = Provider.of<TaskListViewModel>(context, listen: false);
    Provider.of<CategoryListViewModel>(context, listen: false)
        .getCategories(userId: user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final task = widget.taskModel;
    final vm = Provider.of<CategoryListViewModel>(context);
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
                                Convert.upperCase(
                                    text: addTaskViewModel.title),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                              Convert.upperCase(text: addTaskViewModel.description),
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
                                            descriptionController,
                                        onSave: (newTitle, newDescription) {
                                          setState(() {
                                            addTaskViewModel.title = newTitle;
                                            addTaskViewModel.description = newDescription;
                                          });
                                        },
                                      );
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
                        _getCalendar(task.date);
                      },
                      text: Convert.getDate(date: _selectedDate),
                      topicIcon: Icons.calendar_month_outlined,
                      topic: "Task Date"),
                  SizedBox(
                    height: 30,
                  ),
                  TaskRow(
                      function: () {
                        _getTime(Convert.getTime(time: task.time));
                      },
                      text: Convert.convertTimeOfDayToString(time: _timeOfDay),
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
                              return ChooseCategoryWidget(
                                  categoryListViewModel: vm,
                                  function: (categoryModel) {
                                    setState(() {
                                      addTaskViewModel.category = categoryModel;
                                    });
                                  });
                            });
                      },
                      text: addTaskViewModel.category.category,
                      btnIcon: IconData(
                        int.parse(addTaskViewModel.category.icon),
                        fontFamily: 'MaterialIcons',
                      ),
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
                              return TaskPriorityWidget(
                                selectIndex: task.priority,
                                function: (value) {
                                  setState(() {
                                    addTaskViewModel.priority = value + 1;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            });
                      },
                      text: addTaskViewModel.priority.toString(),
                      btnIcon: Icons.flag_outlined,
                      topicIcon: Icons.flag_outlined,
                      topic: "Task Priority"),
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
                                      title: task.title,
                                      function: () async {
                                        int r = await FbHandler.deleteDoc(
                                            collection: [
                                              "user",
                                              "task"
                                            ],
                                            docId: [
                                              user!.uid,
                                              task.id.toString()
                                            ]);
                                        if (r == resOk) {
                                          await taskListViewModel
                                              .getAllTasks(userId: user!.uid)
                                              .whenComplete(() => Fluttertoast
                                                      .showToast(
                                                          msg:
                                                              'Task deleted Successfully')
                                                  .whenComplete(() =>
                                                      openTodoListAfterDelete(
                                                          context, user!.uid)));
                                        }
                                      });
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
                    onpress: () async {
                      setState(() {
                        addTaskViewModel.id = task.id;
                        addTaskViewModel.date = _selectedDate;
                        addTaskViewModel.time =
                            "${_timeOfDay.hour}:${_timeOfDay.minute}";
                      });

                      await addTaskViewModel.updateTodo(userId: user!.uid);
                      await taskListViewModel
                          .getAllTasks(userId: user!.uid)
                          .whenComplete(() => Fluttertoast.showToast(
                                  msg: 'Task updated Successfully')
                              .whenComplete(() =>
                                  openTodoListAfterDelete(context, user!.uid)));
                    },
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

  _getCalendar(DateTime date) async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: date,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (newDate == null) {
      return;
    }
    setState(() {
      _selectedDate = newDate;
    });
  }

  _getTime(String time) {
    showTimePicker(
            context: context, initialTime: Convert.convertTime(time: time))
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }
}
