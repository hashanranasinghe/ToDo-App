import 'package:flutter/material.dart';
import 'package:todo_app/screens/Task/calendar_screen.dart';
import 'package:todo_app/screens/Task/home_screen.dart';
import 'package:todo_app/screens/focus/focus_screen.dart';
import 'package:todo_app/screens/user/user_profile_screen.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/Task_priority_widget.dart';
import 'package:todo_app/widgets/choose_category_widget.dart';
import 'package:todo_app/widgets/text_field.dart';



class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 2;
  late DateTime _selectedDate;
  late TimeOfDay _timeOfDay;
  List<Widget> _screens = [
    HomeScreen(),
    CalendarScreen(),
    HomeScreen(),
    FocusScreen(),
    UserProfileScreen()
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _screens[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              selectedIconTheme: IconThemeData(color: kPrimaryButtonColor),
              type: BottomNavigationBarType.fixed,
              backgroundColor: kPrimaryBackgroundColor,
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryButtonColor,
                    ),
                    child: IconButton(
                        onPressed: () {
                          _showAddModal(context);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer_sharp),
                  label: 'Focus',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 30,
            top: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Task",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                TextFieldWidget(
                  label: "Title",
                  onchange: (value) {},
                  valid: (value) {},
                  save: (value) {},
                  controller: titleController,
                ),
                TextFieldWidget(
                  label: "Description",
                  onchange: (value) {},
                  valid: (value) {},
                  save: (value) {},
                  controller: descriptionController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _getCalendar();
                          },
                          icon: Icon(Icons.calendar_month_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            _getTime();
                          },
                          icon: Icon(Icons.timer_outlined),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ChooseCategoryWidget();
                                  });
                            },
                            icon: Icon(Icons.category_outlined)),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskPriorityWidget();
                                });
                          },
                          icon: Icon(Icons.flag_outlined),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.send_outlined,
                            color: kPrimaryButtonColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _getCalendar() async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.day,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (newDate == null) {
      return;
    }
    setState(() {
      _selectedDate = newDate;
    });
  }

  _getTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }
}
