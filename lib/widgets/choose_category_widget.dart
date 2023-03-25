import 'package:flutter/material.dart';
import 'package:todo_app/models/category_model.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/utils/navigation.dart';
import 'package:todo_app/view%20models/category%20view%20model/category_list_view_model.dart';
import 'package:todo_app/widgets/button_field.dart';

class ChooseCategoryWidget extends StatefulWidget {
  final CategoryListViewModel categoryListViewModel;
  final Function(CategoryModel) function;

  const ChooseCategoryWidget(
      {Key? key, required this.categoryListViewModel, required this.function})
      : super(key: key);

  @override
  State<ChooseCategoryWidget> createState() => _ChooseCategoryWidgetState();
}

class _ChooseCategoryWidgetState extends State<ChooseCategoryWidget> {
  int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    int itemCount = widget.categoryListViewModel.categories.length +
        1; // replace with your actual item count
    double itemHeight =
        100; // replace with the height of each item in the GridView

    double maxHeight = MediaQuery.of(context).size.height *
        0.9; // set a maximum height for the dialog

    double gridViewHeight = (itemCount / 3).ceil() *
        itemHeight; // calculate the height of the GridView

    double dialogHeight = gridViewHeight +
        200; // add some extra padding for the title, divider, and buttons

    if (dialogHeight > maxHeight) {
      dialogHeight = maxHeight; // cap the height at the maximum height
    }

    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          constraints: BoxConstraints(maxHeight: dialogHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Choose Category",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
              _updateUi(widget.categoryListViewModel),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ButtonField(
                  fontsize: 15,
                  pleft: 50,
                  pright: 50,
                  onpress: () {
                    Navigator.pop(context);
                  },
                  text: "Add Category",
                ),
              )
            ],
          ),
        ));
  }

  Widget _updateUi(CategoryListViewModel vm) {
    switch (vm.status) {
      case Status.loading:
        return Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      case Status.success:
        return SingleChildScrollView(
            child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount:
              vm.categories.length + 1, // add 1 for the "Add Category" item
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == vm.categories.length) {
              // render "Add Category" item
              return InkWell(
                onTap: () {
                  Navigator.pop(context);
                  openAddCategory(context);
                },
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(
                                Icons.add,
                                size: 30,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Create New",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              );
            } else {
              // render category item
              bool isSelected = index == _selectedIndex;
              final category = vm.categories[index];
              Color itemColor = isSelected
                  ? kPrimaryButtonColor
                  : Color(int.parse(category.color, radix: 16))
                      .withOpacity(1.0);
              final int icon = int.parse(category.icon);
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = index; // update the selected index
                  });
                  final categoryModel = CategoryModel(
                      id: category.id,
                      category: category.category,
                      icon: category.icon,
                      color: category.color);
                  widget.function(categoryModel);
                },
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(
                                IconData(icon, fontFamily: 'MaterialIcons'),
                                size: 30),
                            decoration: BoxDecoration(
                                color: itemColor,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      category.category,
                      style: TextStyle(
                          color:
                              isSelected ? kPrimaryButtonColor : Colors.white),
                    )
                  ],
                ),
              );
            }
          },
        ));
      case Status.empty:
        return Align(
          alignment: Alignment.center,
          child: Text("No Category found...."),
        );
    }
  }
}
