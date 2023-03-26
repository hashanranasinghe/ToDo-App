import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const logo = "assets/images/logo.png";

//don't change black its effect to the calendar
ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  colorScheme: ColorScheme(
    background: Colors.white,
    brightness: Brightness.dark,
    primary: kPrimaryButtonColor,
    onPrimary: Colors.black,
    onBackground: Colors.white,
    secondary: Colors.white,
    onSurface: Colors.white,
    onSecondary: Colors.white,
    error: kPrimaryErrorColor,
    onError: kPrimaryErrorColor,
    surface: Colors.black,
  ).copyWith(secondary: Colors.white),
);

const Color kPrimaryButtonColor = Color(0xFF8687E7);

const Color kPrimaryBackgroundColor = Color(0xFF121212);

const Color kPrimaryTileColor = Color(0xFF272727);

const kPrimaryTextColor = Color(0xFFAFAFAF);

const kPrimaryErrorColor = Color(0xFFFF4949);

const List<IconData> icons = [
  Icons.access_alarm,
  Icons.accessibility,
  Icons.add,
  Icons.add_circle_outline,
  Icons.school_outlined,
  Icons.assignment,
  Icons.attach_file,
  Icons.attach_money,
  Icons.backup,
  Icons.book,
  Icons.brightness_5,
  Icons.bug_report,
  Icons.build,
  Icons.business_center,
  Icons.camera,
  Icons.card_giftcard,
  Icons.check_circle_outline,
  Icons.chrome_reader_mode,
  Icons.cloud,
  Icons.color_lens,
];

List<Color> colors = List.generate(20, (index) {
  return Color.fromARGB(
    255,
    Random().nextInt(200) + 55,
    Random().nextInt(200) + 55,
    Random().nextInt(200) + 55,
  );
});

const int resOk = 1;
const int resFail = 0;
const String successCode = "successful";

class Convert {
  static String getColorString({required Color color}) {
    String colorString = color.toString();
    RegExp regExp = RegExp(
        r"0xff([a-fA-F0-9]+)"); // Matches "0xff" followed by any number of hexadecimal digits
    RegExpMatch? match = regExp
        .firstMatch(colorString); // Search for the pattern in the color string
    String? hexValue =
        match?.group(1); // Extract the hexadecimal value from the match
    print(hexValue);
    return hexValue.toString();
  }

  static String getTime({required String time}) {
    List<String> parts = time.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);
    final DateFormat formatter = DateFormat('h:mm a');
    String timeString = formatter
        .format(DateTime(2023, 1, 1, timeOfDay.hour, timeOfDay.minute));
    return timeString;
  }

  static String getDate({required DateTime date}) {
    date = DateTime(date.year, date.month, date.day);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (date.isAtSameMomentAs(today)) {
      return "Today At ";
    } else if (date.isAtSameMomentAs(today.add(Duration(days: 1)))) {
      return "Tomorrow At ";
    } else if (date.isAtSameMomentAs(today.subtract(Duration(days: 1)))) {
      return "Yesterday At ";
    } else {
      String day = "${DateFormat('yyyy MMMM d').format(date)} At ";
      return day;
    }
  }


  static String upperCase({required String text}){
    String capitalizedText = text.substring(0, 1).toUpperCase() + text.substring(1);
    return capitalizedText;
  }
}
