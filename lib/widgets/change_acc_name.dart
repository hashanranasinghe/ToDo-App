import 'package:flutter/material.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/button_field.dart';
import 'package:todo_app/widgets/text_field.dart';

class ChangeAccountName extends StatefulWidget {
  final TextEditingController nameController;
  final Function(String) onUpdate;
  const ChangeAccountName(
      {Key? key, required this.nameController, required this.onUpdate})
      : super(key: key);

  @override
  State<ChangeAccountName> createState() => _ChangeAccountNameState();
}

class _ChangeAccountNameState extends State<ChangeAccountName> {
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
              Align(alignment: Alignment.center, child: Text("Change Name")),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              if (!isSelected) ...[
                TextFieldWidget(
                    label: "Name",
                    onchange: (value) {},
                    valid: (value) {},
                    save: (value) {},
                    controller: widget.nameController)
              ] else ...[
                InkWell(
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    child: Text(
                      widget.nameController.text,
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
                    onpress: () {
                      widget.onUpdate(widget.nameController.text);
                      Navigator.pop(context);
                    },
                    text: "Update",
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
