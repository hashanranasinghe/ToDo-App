import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/services/auth/signin_mannager.dart';
import 'package:todo_app/services/firebase/fb_handeler.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_list_view_model.dart';
import 'package:todo_app/view%20models/user%20view%20model/userViewModel.dart';
import 'package:todo_app/widgets/change_acc_name.dart';
import 'package:todo_app/widgets/popup_dialog.dart';
import 'package:todo_app/widgets/setting_list_tile.dart';
import 'package:todo_app/widgets/task_count_card.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<TaskListViewModel>(context, listen: false)
        .getAllTasks(userId: widget.userId);
  }


  TextEditingController nameController= TextEditingController();
  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<TaskListViewModel>(context);
    final length = vm.tasks.length;
    vm.tasks.removeWhere((element) => element.isDone == true);
    return Consumer<UserViewModel>(builder: (context, userViewModel, child) {
      if (userViewModel.userModel == null) {
        userViewModel.getCurrentUser(id: user!.uid);
        return const Center(child: CircularProgressIndicator());
      } else {
        nameController.text = userViewModel.userModel!.name.toString();
        return Scaffold(
            body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                            userViewModel.userModel!.name,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TaskCountCard(text: "${vm.tasks.length} task left"),
                      TaskCountCard(
                          text: "${length - vm.tasks.length} task done")
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Usage"),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "My Apps",
                      icon: Icons.apps,
                      function: () {
                        openUsage(context);
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "Usage Statistics",
                      icon: Icons.graphic_eq_rounded,
                      function: () {
                        openUsageStat(context);
                      }),
                  Text("Settings"),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "App Settings",
                      icon: Icons.settings_outlined,
                      function: () {}),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Account"),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "Change Account Name",
                      icon: CupertinoIcons.profile_circled,
                      function: () {
                        showDialog(context: context, builder: (context){
                          return ChangeAccountName(nameController: nameController, onUpdate: (String name)async {
                            final UserModel userModel = UserModel(name: name, email: user!.email.toString());
                           int res = await FbHandler.updateUserDoc(userModel.toMap(), user!.uid);
                            userViewModel.getCurrentUser(id: user!.uid);
                           if(res == resOk){
                             Fluttertoast.showToast(msg: 'Name is updated successfully');
                           }else{
                             Fluttertoast.showToast(msg: 'Something went to wrong');
                           }
                          },);
                        });

                      }),
                  Text("ToDo us"),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "About us",
                      icon: CupertinoIcons.book_circle_fill,
                      function: () {}),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "FAQ", icon: Icons.info_outline, function: () {}),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "Help & FeedBack",
                      icon: Icons.double_arrow_outlined,
                      function: () {}),
                  SizedBox(
                    height: 10,
                  ),
                  SettingListTile(
                      text: "Support US",
                      icon: Icons.thumb_up_alt_outlined,
                      function: () {}),
                  GestureDetector(
                    onTap: () {
                      PopupDialog.showPopupLogout(
                          context, "Do you want top log out?", "", () {
                        SignInManager().signOut();
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_outlined,
                          color: kPrimaryErrorColor,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 18, color: kPrimaryErrorColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ));
      }
    });
  }
}
