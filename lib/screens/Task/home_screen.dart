import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/view%20models/filter%20view%20model/filter_view_model.dart';


import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/widgets/text_field.dart';
import 'package:todo_app/widgets/todo_list_card.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late List<TaskListViewModel> filteredTasks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<TaskListViewModel>(context, listen: false)
        .getAllTasks(userId: user!.uid);
    Provider.of<FilterListViewModel>(context, listen: false)
        .getCurrentFilters();
    searchController.addListener(() {
      setState(() {
        Provider.of<TaskListViewModel>(context, listen: false).getSearchTasks(
            userId: user!.uid, query: searchController.text);
      });
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskListViewModel>(context);
    final fm = Provider.of<FilterListViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.75,
                  child: TextFieldWidget(
                      label: "Search Your Task",
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: Colors.white,
                      ),
                      onchange: (value) {},
                      valid: (value) {},
                      save: (value) {},
                      controller: searchController),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          openFilters(context);
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage(filter),
                          backgroundColor: Colors.transparent,
                          radius: 30.0,
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: CircleAvatar(
                            backgroundColor: kPrimaryButtonColor,
                            radius: 10.0,
                            child: Text(
                              fm.count.toString(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              print(taskId);
              print(user?.uid);
              final TaskModel taskModel = await FbHandler.getTask(
                  userId: user!.uid, taskId: taskId);
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
