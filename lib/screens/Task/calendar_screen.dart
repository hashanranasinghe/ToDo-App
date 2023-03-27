import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 600,
            child: ListView.builder(
                itemCount: vm.tasks.length,
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

                  print(vm.tasks);
                  print(eventsMap);
                  return Calendar(
                    startOnMonday: true,
                    weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
                    events: eventsMap,
                    eventListBuilder: (context, index) {
                      return TodoListCard(
                          function: (value) {}, tasks: vm.tasks);
                    },
                    onRangeSelected: (range) =>
                        print('Range is ${range.from}, ${range.to}'),
                    onDateSelected: (date) => _handleNewDate(date),
                    isExpandable: true,
                    eventDoneColor: Colors.green,
                    selectedColor: Colors.pink,
                    todayColor: Colors.blue,
                    eventColor: Colors.grey,
                    todayButtonText: 'Today',
                    expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                    dayOfWeekStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 11),
                  );
                }),
          )
        ],
      ),
    );
  }

  void _handleNewDate(date) {
    print('Date selected: $date');
  }
}
