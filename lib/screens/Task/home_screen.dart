import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/widgets/text_field.dart';
import 'package:todo_app/widgets/todo_list_card.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TaskListViewModel>(context, listen: false)
        .getAllTasks(userId: widget.userId);
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskListViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              TextFieldWidget(
                  label: "Search Your Task",
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                  ),
                  onchange: (value) {},
                  valid: (value) {},
                  save: (value) {},
                  controller: searchController),
              SizedBox(
                height: 20,
              ),
              _updateUi(vm)
            ],
          ),
        ),
      ),
    );
  }
  Widget _updateUi(TaskListViewModel vm) {
    switch (vm.status) {
      case Status.loading:
        return Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      case Status.success:
        return TodoListCard(function: (){}, tasks: vm.tasks);
      case Status.empty:
        return Align(
          alignment: Alignment.center,
          child: Text("No forum found...."),
        );
    }
  }
}
