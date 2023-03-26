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

    final today = DateTime.now();
    final todayTasks = results
        .where((task) =>
            task.date.year == today.year &&
            task.date.month == today.month &&
            task.date.day == today.day)
        .toList();
    final beforeTasks =
        results.where((task) => task.date.isBefore(today)).toList();
    final afterTasks =
        results.where((task) => task.date.isAfter(today)).toList();

    todayTasks.sort((a, b) => a.priority.compareTo(b.priority));

    beforeTasks.sort((a, b) => a.priority.compareTo(b.priority));
    afterTasks.sort((a, b) => a.priority.compareTo(b.priority));

    final taskIds = <String>{};
    final uniqueTasks = <TaskViewModel>[];
    for (final task in afterTasks) {
      if (taskIds.contains(task.id)) {
        continue;
      }
      taskIds.add(task.id.toString());
      uniqueTasks.add(TaskViewModel(taskModel: task));
    }
    for (final task in todayTasks) {
      if (taskIds.contains(task.id)) {
        continue;
      }
      taskIds.add(task.id.toString());
      uniqueTasks.add(TaskViewModel(taskModel: task));
    }

    for (final task in beforeTasks) {
      if (taskIds.contains(task.id)) {
        continue;
      }
      taskIds.add(task.id.toString());
      uniqueTasks.add(TaskViewModel(taskModel: task));
    }



    tasks = uniqueTasks;
    print(tasks);
    status = tasks.isEmpty ? Status.empty : Status.success;

    notifyListeners();
  }
}
