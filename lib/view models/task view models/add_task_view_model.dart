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
    await FbHandler.createOwnDoc(
        id: userId,
        collectionPathOwn: "user",
        collectionPath: "task",
        model: taskModel.toMap());
    notifyListeners();
  }

  Future<void> updateTodo({required String userId}) async {
    final taskModel = TaskModel(
        id: id,
        title: title,
        description: description,
        priority: priority,
        date: date,
        time: time,
        isDone: isDone,
        category: category);
    await FbHandler.updateDoc(
        taskModel.toMap(), ["user", "task"], [userId, taskModel.id.toString()]);
    notifyListeners();
  }
}
