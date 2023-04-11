import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/constraints.dart';

class AppCardList extends StatelessWidget {
  final Uint8List icon;
  final String packageName;
  final String lastTime;
  final String foregroundUsageInMinutes;
  AppCardList(
      {Key? key,
      required this.icon,
      required this.packageName,
      required this.lastTime,
      required this.foregroundUsageInMinutes})
      : super(key: key);

  final dateFormatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('hh:mm a');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.transparent,
            child: Image.memory(icon),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(Convert.nameFormat(packageName)),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'Last time used: ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(lastTime)))} | ${timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(lastTime)))}',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Today usage: ${Convert.timeFormat(foregroundUsageInMinutes)}",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
