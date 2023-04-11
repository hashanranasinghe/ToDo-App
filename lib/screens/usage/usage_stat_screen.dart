import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/app_usage_model.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/piechart_details.dart';

class UsageStatScreen extends StatefulWidget {
  final List<AppUsageModel> newList;
  const UsageStatScreen({Key? key, required this.newList}) : super(key: key);

  @override
  State<UsageStatScreen> createState() => _UsageStatScreenState();
}

class _UsageStatScreenState extends State<UsageStatScreen> {
  int touchedIndex = 0;
  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    if (widget.newList.isNotEmpty) {
      setState(() {
        isLoad = true;
      });
    }
    double totalForegroundTime = widget.newList.fold(
        0, (total, element) => total + double.parse(element.foregroundTime));
    widget.newList.removeWhere((element) =>
        (double.parse(element.foregroundTime) / totalForegroundTime * 100.0) <
        1.0);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Usage Statistics"),
          centerTitle: true,
        ),
        body: isLoad == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 200,
                    child: PieChart(PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: showingSections(),
                    )),
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.newList.length,
                        itemBuilder: (context, index) {
                          final app = widget.newList[index];
                          return PieChartDetails(
                            icon: app.icon,
                            percentage:
                                "${(double.parse(app.foregroundTime) / totalForegroundTime * 100.0).toStringAsFixed(2)}%",
                          );
                        }),
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()));
  }

  List<PieChartSectionData> showingSections() {
    double totalForegroundTime = widget.newList.fold(
        0, (total, element) => total + double.parse(element.foregroundTime));
    widget.newList.removeWhere((element) =>
        (double.parse(element.foregroundTime) / totalForegroundTime * 100.0) <
        1.0);

    return List.generate(widget.newList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 210.0 : 200.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final foregroundTime = double.parse(widget.newList[i].foregroundTime);
      final app = Convert.nameFormat(widget.newList[i].packageName);
      final icon = widget.newList[i].icon;
      Color color = colors[i];
      final percentage = foregroundTime / totalForegroundTime * 100.0;
      return PieChartSectionData(
          color: color,
          value: double.parse(percentage.toStringAsFixed(2)),
          title: "${double.parse(percentage.toStringAsFixed(2))}%",
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          badgeWidget: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.transparent,
            child: Image.memory(icon),
          ),
          badgePositionPercentageOffset: 0.97);
    });
  }
}
