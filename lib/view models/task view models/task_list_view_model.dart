import 'package:flutter/cupertino.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_view_model.dart';

enum Status { loading, empty, success }

class TaskListViewModel extends ChangeNotifier {
  List<TaskViewModel> tasks = <TaskViewModel>[];
  Status status = Status.empty;
  Future<void> getAllTasks() async {
    status = Status.loading;
  }
}
