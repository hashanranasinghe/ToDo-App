import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget widget;
  const FilterCard(
      {Key? key, required this.icon, required this.title, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), trailing: widget);
  }
}
