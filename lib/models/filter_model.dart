import 'package:shared_preferences/shared_preferences.dart';

class FilterModel {
  bool? isAllTodos;
  String? category;
  int? priority;

  FilterModel({this.isAllTodos, this.category, this.priority});

  static Future<FilterModel> getFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FilterModel filterModel = FilterModel(
        isAllTodos: prefs.getBool("_isAllToDos"),
        category: prefs.getString("category"),
        priority: prefs.getInt("priority"));
    return filterModel;
  }
}
