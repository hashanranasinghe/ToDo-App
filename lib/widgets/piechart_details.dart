import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PieChartDetails extends StatelessWidget {
  final Uint8List icon;
  final String percentage;
  const PieChartDetails(
      {Key? key, required this.icon, required this.percentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Image.memory(icon),
                  ),
                  Text(percentage,style: TextStyle(
                    fontSize: 20
                  ),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
