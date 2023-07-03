import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_view_model.dart';

enum Status { loading, empty, success }

class TaskListViewModel extends ChangeNotifier {
  List<TaskViewModel> tasks = <TaskViewModel>[];
  Status status = Status.empty;
  bool _isAllToDos = false;
  String _filterCategory = "";
  int _filterPriority = 0;
  Future<void> getAllTasks({required String userId}) async {
    status = Status.loading;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final results = await FbHandler.getAllTasks(id: userId);
    tasks = results.map((task) => TaskViewModel(taskModel: task)).toList();

    if (prefs.getBool("_isAllToDos") != null) {
      _isAllToDos = prefs.getBool("_isAllToDos")!;
    }
    if (prefs.getString("category") != null) {
      _filterCategory = prefs.getString("category")!;
    } else {
      _filterCategory = "";
    }
    if (prefs.getInt("priority") != null) {
      _filterPriority = prefs.getInt("priority")!;
    } else {
      _filterPriority = 0;
    }

    if (_isAllToDos == false) {
      tasks = tasks.where((task) => task.isDone == false).toList();
    }
    if (_filterCategory != "") {
      tasks = tasks
          .where((task) =>
              task.category.category.toLowerCase() ==
              _filterCategory.toLowerCase())
          .toList();
    }
    if (_filterPriority != 0) {
      tasks = tasks.where((task) => task.priority == _filterPriority).toList();
    }

    status = tasks.isEmpty ? Status.empty : Status.success;

    notifyListeners();
  }

  Future<void> getSearchTasks(
      {required String userId, required String query}) async {
    status = Status.loading;
    final results = await FbHandler.getAllTasks(id: userId);
    tasks = results.map((task) => TaskViewModel(taskModel: task)).toList();
    tasks = tasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    status = tasks.isEmpty ? Status.empty : Status.success;
    notifyListeners();
  }
}
