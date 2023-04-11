import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/view%20models/category%20view%20model/add_category_view_model.dart';
import 'package:todo_app/view%20models/category%20view%20model/category_list_view_model.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/text_field.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  late AddCategoryViewModel addCategoryViewModel;
  late CategoryListViewModel categoryListViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addCategoryViewModel =
        Provider.of<AddCategoryViewModel>(context, listen: false);
    categoryListViewModel= Provider.of<CategoryListViewModel>(context,listen: false);
  }

  IconData? icon;
  Color? selectedColor;

  TextEditingController categoryController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 80, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create new category ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                TextFieldWidget(
                  onchange: (value) {},
                  valid: (value) {},
                  save: (value) {},
                  controller: categoryController,
                  label: "Category name",
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Category icon:",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                if (icon == null) ...[
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color?>(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Future.delayed(Duration(milliseconds: 50), () {
                          _showIconPickerDialog(context);
                        });
                      },
                      child: Text(
                        "Choose icon from library",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ))
                ] else ...[
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: kPrimaryTileColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          icon,
                          size: 50,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryButtonColor.withOpacity(0.25)),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                icon = null;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            ),
                          )),
                    ],
                  ),
                ],
                SizedBox(
                  height: 10,
                ),
                Text("Category color:"),
                if (selectedColor == null) ...[
                  SizedBox(
                    height: 100, // Set a fixed height for the container
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = colors[index];
                            });
                            print(
                                'Selected color: ${Convert.getColorString(color: selectedColor!)}');
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedColor,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                          height: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryButtonColor.withOpacity(0.25)),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedColor = null;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            ),
                          )),
                    ],
                  ),
                ],
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 15),
                        )),
                    SizedBox(
                      width: 80,
                    ),
                    ButtonField(
                      onpress: () async {
                        _addCategory();
                      },
                      text: "Create Category",
                      fontsize: 15,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showIconPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select the icon",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.white,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: icons.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          icon = icons[index];
                        });
                        print(icon?.codePoint);
                        Navigator.pop(
                            context, icons[index]); // Return the selected icon
                      },
                      child: Icon(icons[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((selectedIcon) {
      if (selectedIcon != null) {
        // Handle the selected icon here
        print('Selected icon: $selectedIcon');
      }
    });
  }

  _addCategory() async {
    addCategoryViewModel.category = categoryController.text;
    addCategoryViewModel.color = Convert.getColorString(color: selectedColor!);
    addCategoryViewModel.icon = icon!.codePoint.toString();

    await addCategoryViewModel.addCategory(userId: user!.uid);
    await categoryListViewModel.getCategories(userId: user!.uid).whenComplete(() =>
        Fluttertoast.showToast(msg: 'Category added Successfully')
            .whenComplete(() => Navigator.pop(context)));
  }
}
