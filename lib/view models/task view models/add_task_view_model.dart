import 'package:flutter/material.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';

class AddTaskViewModel extends ChangeNotifier {
  late String? id;
  late String title;
  late String description;
  late int priority;
  late CategoryModel category;
  late DateTime date;
  late String time;
  late bool isDone;

  Future<void> addTodo({required String userId}) async {
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
    await FbHandler.createOwnDoc(id: userId, collectionPathOwn: "user", collectionPath: "task", model: taskModel.toMap());
    notifyListeners();
  }
}
