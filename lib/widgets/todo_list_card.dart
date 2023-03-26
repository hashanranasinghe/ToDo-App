import 'package:flutter/material.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/view%20models/task%20view%20models/task_view_model.dart';

class TodoListCard extends StatefulWidget {
  final List<TaskViewModel> tasks;
  final Function(String) function;
  const TodoListCard({Key? key, required this.function, required this.tasks})
      : super(key: key);

  @override
  State<TodoListCard> createState() => _TodoListCardState();
}

class _TodoListCardState extends State<TodoListCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];

          return InkWell(
            onTap: () {
              widget.function(task.id.toString());
            },
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Convert.upperCase(text: task.title),
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: screenWidth*0.35,
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(

                                  Convert.getDate(date: task.date),
                                  style: TextStyle(
                                      color: Color(0xFFAFAFAF), fontSize: 12),
                                ),
                                Text(
                                  Convert.getTime(time: task.time),
                                  style: TextStyle(
                                      color: Color(0xFFAFAFAF), fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(int.parse(task.category.color, radix: 16)).withOpacity(1.0),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: SizedBox(
                                      width: screenWidth*0.23,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Icon(
                                            IconData(
                                              int.parse(task.category.icon),
                                              fontFamily: 'MaterialIcons',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            task.category.category,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.flag_outlined),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(task.priority.toString())
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )),
          );
        });
  }
}
