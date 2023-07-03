import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/button_field.dart';

class TaskPriorityWidget extends StatefulWidget {
  final Function(int) function;
  final int? selectIndex;
  final bool filter;
  const TaskPriorityWidget(
      {Key? key, required this.function, this.selectIndex, this.filter = false})
      : super(key: key);

  @override
  State<TaskPriorityWidget> createState() => _TaskPriorityWidgetState();
}

class _TaskPriorityWidgetState extends State<TaskPriorityWidget> {
  late int selectIndex;
  @override
  void initState() {
    super.initState();
    widget.selectIndex == null
        ? selectIndex = -1
        : selectIndex = widget.selectIndex! - 1;
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = 20; // replace with your actual item count
    double itemHeight =
        70; // replace with the height of each item in the GridView

    double maxHeight = MediaQuery.of(context).size.height *
        0.9; // set a maximum height for the dialog

    double gridViewHeight = (itemCount / 4).ceil() *
        itemHeight; // calculate the height of the GridView

    double dialogHeight = gridViewHeight +
        200; // add some extra padding for the title, divider, and buttons

    if (dialogHeight > maxHeight) {
      dialogHeight = maxHeight; // cap the height at the maximum height
    }

    return Dialog(
        child: Container(
      constraints: BoxConstraints(maxHeight: dialogHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Row(
              mainAxisAlignment: (widget.filter ==true)?MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
              children: [
                Text(
                  "Task Priority",
                  style: TextStyle(fontSize: 20),
                ),
                if(widget.filter ==true)...[
                  IconButton(onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.remove("priority");
                    Navigator.pop(context);
                  }, icon: Icon(Icons.delete_outline_rounded))
                ]
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              thickness: 1,
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = index == selectIndex;
                Color itemColor =
                    isSelected ? kPrimaryButtonColor : kPrimaryTileColor;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectIndex = index; // update the selected index
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    color: itemColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flag_outlined),
                          Text('${index + 1}')
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 20),
                    )),
                ButtonField(
                  pleft: 50,
                  pright: 50,
                  onpress: () {
                    widget.function(selectIndex);
                  },
                  text: "Save",
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
