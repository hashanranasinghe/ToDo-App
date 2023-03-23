import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/category_model.dart';

class AddCategoryViewModel extends ChangeNotifier {
  late String id;
  late String category;
  late String icon;
  late String color;

  Future<void> addCategory() async {
    final categoryModel =
        CategoryModel(id: id, category: category, icon: icon, color: color);

    notifyListeners();
  }
}
