
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/category_model.dart';

class TaskModel {
  String? id;
  String title;
  String description;
  int priority;
  CategoryModel category;
  DateTime date;
  String time;
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
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'],
      category: CategoryModel.fromMap(map['category']));

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'priority': priority,
        'date': date,
        'time': time,
        'category': category.toMap()
      };
}
