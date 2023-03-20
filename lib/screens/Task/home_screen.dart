import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/widgets/text_field.dart';
import 'package:todo_app/widgets/todo_list_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              TodoListCard(
                function: () {
                  openTask(context);
                },
                title: 'Do Math Homework',
                time: 'Today At 16.45',
                category: 'University',
                color: Colors.blue,
                priority: '1',
                icon: Icons.school_outlined,
              )
            ],
          ),
        ),
      ),
    );
  }
}
