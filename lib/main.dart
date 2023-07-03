import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/intro/splash_screen.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/view%20models/category%20view%20model/add_category_view_model.dart';
import 'package:todo_app/view%20models/category%20view%20model/category_list_view_model.dart';
import 'package:todo_app/view%20models/filter%20view%20model/filter_view_model.dart';
import 'package:todo_app/view%20models/task%20view%20models/add_task_view_model.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/view%20models/user%20view%20model/userViewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FilterListViewModel()),
    ChangeNotifierProvider(create: (_) => UserViewModel()),
    ChangeNotifierProvider(create: (_) => AddTaskViewModel()),
    ChangeNotifierProvider(create: (_) => AddCategoryViewModel()),
    ChangeNotifierProvider(create: (_) => CategoryListViewModel()),
    ChangeNotifierProvider(create: (_) => TaskListViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const SplashScreen(),
    );
  }
}
