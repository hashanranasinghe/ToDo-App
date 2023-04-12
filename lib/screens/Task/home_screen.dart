import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';

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
  late List<TaskListViewModel> filteredTasks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      Provider.of<TaskListViewModel>(context, listen: false)
          .getAllTasks(userId: widget.userId);

      searchController.addListener(() {
        setState(() {
          Provider.of<TaskListViewModel>(context, listen: false).getSearchTasks(
              userId: widget.userId, query: searchController.text);
        });
      });

  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskListViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;
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
      body: Padding(
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
            Expanded(child: _updateUi(vm)),
            SizedBox(
              height: screenHeight * 0.1,
            )
          ],
        ),
      ),
    );
  }

  Widget _updateUi(TaskListViewModel vm) {
    switch (vm.status) {
      case Status.loading:
        return Align(
          alignment: Alignment.center,
          child: Lottie.asset(loadingAnim, width: 200, height: 200),
        );
      case Status.success:
        return TodoListCard(
            function: (taskId) async {
              final TaskModel taskModel = await FbHandler.getTask(
                  userId: widget.userId, taskId: taskId);
              openTask(context, taskModel);
            },
            tasks: vm.tasks);
      case Status.empty:
        return Align(
          alignment: Alignment.center,
          child: Lottie.asset(todoAnim, width: 300, height: 300),
        );
    }
  }
}
