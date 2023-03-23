import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/category_model.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryModel categoryModel;

  CategoryViewModel({required this.categoryModel});

  String get id => categoryModel.id;

  String get category => categoryModel.category;

  String get icon => categoryModel.icon;

  String get color => categoryModel.color;
}
