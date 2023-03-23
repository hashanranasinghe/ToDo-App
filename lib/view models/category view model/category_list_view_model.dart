import 'package:flutter/material.dart';
import 'package:todo_app/services/testing.dart';
import 'package:todo_app/view%20models/category%20view%20model/category_view_model.dart';

enum Status { loading, empty, success }

class CategoryListViewModel extends ChangeNotifier {
  List<CategoryViewModel> categories = <CategoryViewModel>[];
  Status status = Status.empty;

  Future<void> getCategories() async {
    status = Status.loading;
    final results = await Test.categories();
    categories = results
        .map((category) => CategoryViewModel(categoryModel: category))
        .toList();
    status = categories.isEmpty ? Status.empty : Status.success;

    notifyListeners();
  }
}
