import 'package:flutter/material.dart';

class TodoListCard extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final String category;
  final String priority;
  final IconData icon;
  final Function function;
  const TodoListCard(
      {Key? key,
      required this.title,
      required this.time,
      required this.color,
      required this.category,
      required this.priority,
      required this.icon,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        function();
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
                    Text(title),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      time,
                      style: TextStyle(color: Color(0xFFAFAFAF), fontSize: 12),
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
                                  color: color),
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Icon(icon),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(category)
                                ],
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
                                  Text(priority)
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
  }
}
