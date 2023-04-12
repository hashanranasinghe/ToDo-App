import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:todo_app/models/app_usage_model.dart';
import 'package:todo_app/screens/usage/usage_stat_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/app_card_list.dart';
import 'dart:async';
import 'package:usage_stats/usage_stats.dart';

class UsageScreen extends StatefulWidget {
  final bool myApps;
  const UsageScreen({super.key, required this.myApps});

  @override
  _UsageScreenState createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  List<EventUsageInfo> events = [];
  List<UsageInfo> t = [];
  List<AppInfo> apps = [];
  List<AppUsageModel> newList = [];
  bool isLoad = false;
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

    apps.sort((a, b) => a.packageName!
        .compareTo(b.packageName.toString())); // sort apps by packageName
    t.sort((a, b) => a.packageName!
        .compareTo(b.packageName.toString())); // sort t by packageName

    int i = 0, j = 0;

    while (i < apps.length && j < t.length) {
      if (apps[i].packageName == t[j].packageName) {
        newList.add(AppUsageModel(
            name: t[j].packageName.toString(),
            icon: apps[i].icon!,
            packageName: t[j].packageName.toString(),
            foregroundTime: t[j].totalTimeInForeground!,
            lastTime: t[j].lastTimeUsed.toString()));
        i++;
        j++;
      } else if (apps[i].packageName!.compareTo(t[j].packageName.toString()) <
          0) {
        i++;
      } else {
        j++;
      }
    }

    newList.sort((a, b) => (double.parse(a.foregroundTime) / 1000 / 60)
        .compareTo((double.parse(b.foregroundTime) / 1000 / 60)));

    setState(() {
      this.newList = newList;
      isLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.myApps == true
        ? Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text("Applications"),
              centerTitle: true,
            ),
            body: isLoad == true
                ? RefreshIndicator(
                    onRefresh: initUsage,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var app = newList[index];
                          return AppCardList(
                              icon: app.icon,
                              packageName: app.packageName,
                              lastTime: app.lastTime,
                              foregroundUsageInMinutes: app.foregroundTime);
                        },
                        itemCount: newList.length,
                      ),
                    ))
                : Center(child: Lottie.asset(loadingAnim,width: 200,height: 200)))
        : UsageStatScreen(newList: newList,);
  }
}
