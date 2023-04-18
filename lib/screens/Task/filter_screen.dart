import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/checkBox.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isSelected = false;

  Future<void> _loadTotalSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("_isAllToDos") != null) {
      setState(() {
        isSelected = prefs.getBool("_isAllToDos")!;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTotalSeconds();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
              leading: Icon(Icons.done_outline_outlined),
              title: Text("All My ToDos"),
              trailing: CustomCheckBox(
                  checkedFillColor: kPrimaryButtonColor,
                  value: isSelected,
                  onChanged: (value) {
                    if (isSelected == false) {
                      setState(() {
                        isSelected = value;
                      });
                    } else {
                      setState(() {
                        isSelected = value;
                      });
                    }
                  })),
          ButtonField(
            onpress: () {
              _saveAllToDosFilter();
              vm
                  .getAllTasks(userId: user!.uid)
                  .whenComplete(() => Navigator.pop(context));
            },
            text: "Save",
          )
        ],
      ),
    );
  }

  void _saveAllToDosFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("_isAllToDos", isSelected);
  }
}
