import 'package:flutter/material.dart';

class TaskModel {
  String title;
  String description;
  String priority;
  String category;
  DateTime startTime;
  DateTime endTime;
  Color color;
  bool isAllDay;
  bool isDone;

  TaskModel(this.title,
      {this.description = '',
        this.priority = '',
        required this.startTime,
        required this.category,
        required this.endTime,
        this.color = Colors.blue,
        this.isAllDay = false,
        this.isDone = false});
}
