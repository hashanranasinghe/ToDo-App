import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/app_usage_model.dart';
import 'package:todo_app/utils/constraints.dart';
import 'dart:async';
import 'package:usage_stats/usage_stats.dart';

class UsageScreen extends StatefulWidget {
  const UsageScreen({super.key});

  @override
  _UsageScreenState createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  List<EventUsageInfo> events = [];
  List<UsageInfo> t = [];
  List<AppInfo> apps = [];
  List<AppUsageModel> newList = [];

  @override
  void initState() {
    super.initState();
    getInstalledApps();
    initUsage().whenComplete(() => combineList());
  }

  Future<void> getInstalledApps() async {
    apps = await InstalledApps.getInstalledApps(true, true);
  }

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1));
      List<EventUsageInfo> queryEvents =
          await UsageStats.queryEvents(startDate, endDate);
      List<NetworkInfo> networkInfos = await UsageStats.queryNetworkUsageStats(
        startDate,
        endDate,
        networkType: NetworkType.all,
      );
      Map<String?, NetworkInfo?> netInfoMap = {
        for (var v in networkInfos) v.packageName: v
      };
      List<UsageInfo> p = await UsageStats.queryUsageStats(startDate, endDate);
      setState(() {
        events = queryEvents.toList();
        t = p;
      });
    } catch (err) {
      print(err);
    }
  }

  combineList() {
    List<AppUsageModel> newList = [];
    for (int i = 0; i < apps.length; i++) {
      for (int j = 0; j < t.length; j++) {
        if (t[j].packageName == apps[i].packageName) {
          newList.add(AppUsageModel(
              name: t[j].packageName.toString(),
              icon: apps[i].icon!,
              packageName: t[j].packageName.toString(),
              foregroundTime: t[j].totalTimeInForeground!,
              lastTime: t[j].lastTimeUsed.toString()));
        }
      }
    }
    setState(() {
      this.newList = newList;
    });
  }

  final dateFormatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('hh:mm a');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Applications"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: initUsage,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: ListView.builder(
              itemBuilder: (context, index) {
                var app = newList[index];
                // Calculate the foreground usage time in minutes
                var foregroundUsageInMinutes =
                    double.parse(app.foregroundTime) / 1000 / 60;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.transparent,
                        child: Image.memory(app.icon),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(Convert.nameFormat(app.packageName)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Last time used: ${dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(app.lastTime)))} | ${timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(app.lastTime)))}',
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
              },
              itemCount: newList.length,
            ),
          )),
    );
  }
}
