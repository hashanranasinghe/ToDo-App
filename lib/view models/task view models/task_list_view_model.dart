import 'package:flutter/cupertino.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_view_model.dart';

enum Status { loading, empty, success }

class TaskListViewModel extends ChangeNotifier {
  List<TaskViewModel> tasks = <TaskViewModel>[];
  Status status = Status.empty;

  Future<void> getAllTasks({required String userId}) async {
    status = Status.loading;
    final results = await FbHandler.getAllTasks(id: userId);
    tasks = results.map((task) => TaskViewModel(taskModel: task)).toList();
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
