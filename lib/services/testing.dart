import 'dart:convert';

import 'package:flutter/services.dart' as rootBundle;
import 'package:todo_app/models/category_model.dart';

class Test {
  static Future<List<CategoryModel>> categories() async {
    final jsonData =
        await rootBundle.rootBundle.loadString('assets/json/list.json');
    final List<dynamic> jsonList = json.decode(jsonData);
    List<CategoryModel> categoryList =
        jsonList.map((category) => CategoryModel.fromMap(category)).toList();
    return categoryList;
  }
}
