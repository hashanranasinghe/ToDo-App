import 'package:flutter/material.dart';
import 'package:todo_app/models/category_model.dart';

class TaskModel {
  String? id;
  String title;
  String description;
  String priority;
  CategoryModel category;
  DateTime date;
  TimeOfDay time;
  bool isDone;

  TaskModel(
      {this.id,
      required this.title,
      required this.description,
      required this.priority,
      required this.date,
      required this.time,
      required this.category,
      this.isDone = false});

  factory TaskModel.fromMap(map) => TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      date: map['date'],
      time: map['time'],
      category: CategoryModel.fromMap(map['category']));

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'date': date,
        'time': time,
        'category': category.toMap()
      };
}
