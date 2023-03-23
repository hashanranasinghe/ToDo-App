import 'package:flutter/material.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskModel taskModel;

  TaskViewModel({required this.taskModel});

  String? get id => taskModel.id;

  String get title => taskModel.title;

  String get description => taskModel.description;

  int get priority => taskModel.priority;

  CategoryModel get category => taskModel.category;

  DateTime get date => taskModel.date;

  TimeOfDay get time => taskModel.time;

  bool get isDone => taskModel.isDone;
}
