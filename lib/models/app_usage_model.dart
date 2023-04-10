import 'dart:typed_data';

class AppUsageModel {
  String name;
  Uint8List icon;
  String packageName;
  String foregroundTime;
  String lastTime;
  AppUsageModel(
      {required this.name,
      required this.icon,
      required this.packageName,
      required this.foregroundTime,
      required this.lastTime});
}
