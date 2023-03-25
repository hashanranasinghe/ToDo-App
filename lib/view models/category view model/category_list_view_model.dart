import 'package:flutter/material.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/services/testing.dart';
import 'package:todo_app/view%20models/category%20view%20model/category_view_model.dart';

enum Status { loading, empty, success }

class CategoryListViewModel extends ChangeNotifier {
  List<CategoryViewModel> categories = <CategoryViewModel>[];
  Status status = Status.empty;

  Future<void> getCategories({required String userId}) async {
    status = Status.loading;
    final listJson = await Test.categories();
    final listUser = await FbHandler.getAllCategory(id: userId);
    final results = listJson+listUser;
    categories = results
        .map((category) => CategoryViewModel(categoryModel: category))
        .toList();
    status = categories.isEmpty ? Status.empty : Status.success;

    notifyListeners();
  }
}
