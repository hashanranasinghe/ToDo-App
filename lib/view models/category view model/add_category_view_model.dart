import 'package:flutter/cupertino.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';

class AddCategoryViewModel extends ChangeNotifier {
  late String category;
  late String icon;
  late String color;

  Future<void> addCategory({required String userId}) async {
    final categoryModel =
        CategoryModel(category: category, icon: icon, color: color);
    await FbHandler.createOwnDoc(
        id: userId,
        collectionPathOwn: "user",
        collectionPath: "category",
        model: categoryModel.toMap());
    notifyListeners();
  }
}
