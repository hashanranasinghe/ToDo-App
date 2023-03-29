import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function function;
  const SettingListTile(
      {Key? key,
      required this.text,
      required this.icon,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(right: 40),
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      ),
      leading: Icon(icon),
      trailing: IconButton(
        icon: Icon(Icons.arrow_forward_ios_outlined),
        onPressed: () {
          function();
        },
      ),
    );
  }
}
