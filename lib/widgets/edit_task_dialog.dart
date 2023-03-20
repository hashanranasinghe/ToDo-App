import 'package:flutter/material.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/text_field.dart';

class EditTaskDialog extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const EditTaskDialog(
      {super.key,
      required this.titleController,
      required this.descriptionController});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.center, child: Text("Edit Task ")),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              if (!isSelected) ...[
                TextFieldWidget(
                    label: "Title",
                    onchange: (value) {},
                    valid: (value) {},
                    save: (value) {},
                    controller: widget.titleController)
              ] else ...[
                InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    child: Text(
                      "Do Math HomeWork",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
              SizedBox(
                height: 10,
              ),
              if (isSelected) ...[
                TextFieldWidget(
                    label: "Description",
                    onchange: (value) {},
                    valid: (value) {},
                    save: (value) {},
                    controller: widget.descriptionController)
              ] else ...[
                SizedBox(
                  height: 10,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    child: Text(
                      "Do chapter 2 to 5 for next week",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style:
                            TextStyle(color: kPrimaryButtonColor, fontSize: 20),
                      )),
                  ButtonField(
                    onpress: () {},
                    text: "Edit",
                    pright: screenWidth * 0.15,
                    pleft: screenWidth * 0.15,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
