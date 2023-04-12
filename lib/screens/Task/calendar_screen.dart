import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_view_model.dart';
import 'package:todo_app/widgets/todo_list_card.dart';

class CalendarScreen extends StatefulWidget {
  final String userId;
  const CalendarScreen({super.key, required this.userId});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  @override
  void initState() {
    super.initState();
    Provider.of<TaskListViewModel>(context, listen: false)
        .getAllTasks(userId: widget.userId);
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  Map<DateTime, List<CleanCalendarEvent>> eventsMap = {};

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskListViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: screenHeight,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  for (TaskViewModel task in vm.tasks) {
                    DateTime date = task.date;
                    if (eventsMap[date] == null) {
                      eventsMap[date] = [];
                    }
                    if (!eventsMap[date]!
                        .any((e) => e.startTime == task.date)) {
                      eventsMap[date]!.add(CleanCalendarEvent("",
                          endTime: task.date, startTime: task.date));
                    }
                  }
                  return SafeArea(
                    child: Calendar(
                      startOnMonday: true,
                      weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
                      events: eventsMap,
                      eventListBuilder: (context, index) {
                        return _updateUi(vm, screenHeight);
                      },
                      onRangeSelected: (range) =>
                          print('Range is ${range.from}, ${range.to}'),
                      onDateSelected: (date) => _handleNewDate(date),
                      isExpanded: true,
                      isExpandable: true,
                      eventDoneColor: Colors.green,
                      selectedColor: Colors.pink,
                      todayColor: Colors.blue,
                      eventColor: Colors.white,
                      todayButtonText: 'Today',
                      expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                      dayOfWeekStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _updateUi(TaskListViewModel vm, double screenHeight) {
    switch (vm.status) {
      case Status.loading:
        return Align(
          alignment: Alignment.center,
          child: Lottie.asset(loadingAnim, width: 200, height: 200),
        );
      case Status.success:
        return SizedBox(
          height: screenHeight * 0.35,
          child: TodoListCard(
              selectedDay: _selectedDay,
              function: (taskId) async {
                final TaskModel taskModel = await FbHandler.getTask(
                    userId: widget.userId, taskId: taskId);
                openTask(context, taskModel);
              },
              tasks: vm.tasks),
        );
      case Status.empty:
        return Align(
          alignment: Alignment.center,
          child: Lottie.asset(todoAnim, width: 200, height: 200),
        );
    }
  }

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
    });
    print('Date selected: $_selectedDay');
  }
}
