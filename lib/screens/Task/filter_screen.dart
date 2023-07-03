import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/view%20models/category%20view%20model/category_list_view_model.dart';
import 'package:todo_app/view%20models/filter%20view%20model/filter_view_model.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/widgets/Task_priority_widget.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/checkBox.dart';
import 'package:todo_app/widgets/choose_category_widget.dart';
import 'package:todo_app/widgets/filter_card.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isAllToDos = false;
  String category = "";
  int priority = 0;
  Future<void> _loadAllToDosFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("_isAllToDos") != null) {
      setState(() {
        isAllToDos = prefs.getBool("_isAllToDos")!;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAllToDosFilter();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskListViewModel>(context);
    final fm = Provider.of<FilterListViewModel>(context);
    final categories = Provider.of<CategoryListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filters"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FilterCard(
                icon: Icons.done_outline_outlined,
                title: "All My ToDos",
                widget: CustomCheckBox(
                    checkedFillColor: kPrimaryButtonColor,
                    value: isAllToDos,
                    onChanged: (value) {
                      if (isAllToDos == false) {
                        setState(() {
                          isAllToDos = value;
                        });
                      } else {
                        setState(() {
                          isAllToDos = value;
                        });
                      }
                    })),
            Divider(
              thickness: 1,
              color: Colors.white,
            ),
            FilterCard(
                icon: Icons.category_outlined,
                title: "Category",
                widget: IconButton(
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                  onPressed: () async{
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    final categoryName = (prefs.getString("category") != null)
                        ? (prefs.getString("category"))
                        : null;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ChooseCategoryWidget(
                            categoryName: categoryName,
                            filter: true,
                            categoryListViewModel: categories,
                            function: (categoryModel) {
                              setState(() {
                                category = categoryModel.category;
                              });
                            },
                          );
                        });
                  },
                )),
            Divider(
              thickness: 1,
              color: Colors.white,
            ),
            FilterCard(
                icon: Icons.flag_outlined,
                title: "Priority",
                widget: IconButton(
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final index = (prefs.getInt("priority") != null)
                        ? (prefs.getInt("priority"))
                        : null;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TaskPriorityWidget(
                            filter: true,
                            selectIndex: index,
                            function: (value) {
                              value = value + 1;
                              setState(() {
                                priority = value;
                              });
                              Navigator.pop(context);
                            },
                          );
                        });
                  },
                )),
            ButtonField(
              onpress: () async {
                _saveAllToDosFilter();
                fm.getCurrentFilters();
                vm
                    .getAllTasks(userId: user!.uid)
                    .whenComplete(() => Navigator.pop(context));
              },
              text: "Save",
            ),
          ],
        ),
      ),
    );
  }

  void _saveAllToDosFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("_isAllToDos", isAllToDos);
    if (category != "") {
      prefs.setString("category", category);
    }
    if (priority != 0) {
      prefs.setInt("priority", priority);
    }
  }
}
