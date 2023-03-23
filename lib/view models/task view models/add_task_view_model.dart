import 'package:flutter/material.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/models/task_model.dart';

class AddTaskViewModel extends ChangeNotifier {
  late String? id;
  late String title;
  late String description;
  late int priority;
  late CategoryModel category;
  late DateTime date;
  late TimeOfDay time;
  late bool isDone;

  Future<void> addTodo() async {
    final taskModel = TaskModel(
        title: title,
        description: description,
        priority: priority,
        date: date,
        time: time,
        category: category);
    print(taskModel.title);
    print(taskModel.description);
    print(taskModel.priority);
    print(
        "${taskModel.category.id},${taskModel.category.category},${taskModel.category.icon},${taskModel.category.color}");
    print(taskModel.date);
    print(taskModel.time);

    notifyListeners();
  }
}
