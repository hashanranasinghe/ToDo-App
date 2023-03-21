import 'package:flutter/cupertino.dart';

class CategoryModel {
  String id;
  String category;
  IconData icon;
  Color color;

  CategoryModel(
      {required this.id,
      required this.category,
      required this.icon,
      required this.color});

  factory CategoryModel.fromMap(map) => CategoryModel(
      id: map['id'],
      category: map['category'],
      icon: map['icon'],
      color: map['color']);

  Map<String, dynamic> toMap() =>
      {'id': id, 'category': category, 'icon': icon, 'color': color};
}
