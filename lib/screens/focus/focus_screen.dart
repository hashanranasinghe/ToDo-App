import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/constraints.dart';
import 'package:todo_app/widgets/text_field.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});
  @override
  _FocusScreenState createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int _hours = 0;
  int _min = 0;
  int _totalSeconds = 0;
  int _secondsRemaining = 0;
  bool _isPaused = true;
  bool _isStopped = false;
  Timer? _timer;
  DateTime date = DateTime.now();
  TextEditingController hourController = TextEditingController();
  TextEditingController minController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _startTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_secondsRemaining == 0) {
        _totalSeconds = _hours + _min;
        date = date.add(Duration(seconds: _totalSeconds));
        _isPaused = false;
        print(date);
        _secondsRemaining = _totalSeconds;
      } else {
        _isStopped = false;
        prefs.setBool("_isStopped", _isStopped);
        date = DateTime.now().add(Duration(seconds: _secondsRemaining));
        prefs.setString('finishTime', date.toIso8601String());
        print(date);
        _isPaused = false;
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _saveTotalSeconds(_secondsRemaining);
        } else {
          _isPaused = true;
          timer.cancel();
        }
      });
    });
  }

  void _pauseTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isPaused = true;
      _isStopped = true;
      prefs.setBool("_isStopped", _isStopped);
      prefs.setInt('remainingSeconds', _secondsRemaining);
      _timer?.cancel();
    });
  }

  void _resetTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPaused = true;
      _timer?.cancel();
      _totalSeconds = 0;
      _secondsRemaining = 0;
    });
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadTotalSeconds().then((value) {
      if (value == false) {
        _startTimer();
      }
    });
  }

  Future<bool> _loadTotalSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('remainingSeconds').toString() != "null") {
      String? dateTimeString = prefs.getString('finishTime');
      setState(() {
        _isStopped = prefs.getBool("_isStopped")!;
        date = DateTime.parse(dateTimeString!);
        if (_isStopped == false) {
          _secondsRemaining = date
              .difference(DateTime.now())
              .inSeconds; //date.difference(DateTime.now()).inSeconds
        } else {
          _secondsRemaining =
              int.parse(prefs.get('remainingSeconds').toString());
        }

        _totalSeconds = int.parse(prefs.get('totalSeconds').toString());
      });
      print(_isStopped);
      int time = int.parse(prefs.get('remainingSeconds').toString());
      print(time);
    }
    return _isStopped;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _saveTotalSeconds(secondsRemaining) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("_isStopped", _isStopped);
    prefs.setInt('remainingSeconds', secondsRemaining);
    prefs.setInt("totalSeconds", _totalSeconds);
    prefs.setString('finishTime', date.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Focus Screen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: screenWidth * 0.24,
                  child: TextFieldWidget(
                    keybordtype: TextInputType.number,
                    label: "hours",
                    onchange: (value) {
                      setState(() {
                        _hours = int.tryParse(value)! * 3600;
                      });
                    },
                    valid: (value) {},
                    save: (value) {},
                    controller: hourController,
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.24,
                  child: TextFieldWidget(
                    keybordtype: TextInputType.number,
                    label: "min",
                    onchange: (value) {
                      setState(() {
                        _min = int.tryParse(value)! * 60;
                      });
                    },
                    valid: (value) {},
                    save: (value) {},
                    controller: minController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            CircularPercentIndicator(
              backgroundColor: kPrimaryTextColor,
              radius: 150.0,
              lineWidth: 20.0,
              percent: _secondsRemaining / _totalSeconds,
              center: Text(
                "${(_secondsRemaining / 60).floor()}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 40),
              ),
              progressColor: kPrimaryButtonColor,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: _isPaused ? _startTimer : _pauseTimer,
                    icon: _isPaused
                        ? const Icon(
                            Icons.play_circle_fill_rounded,
                            color: kPrimaryButtonColor,
                            size: 80,
                          )
                        : const Icon(
                            Icons.pause_circle_outline_rounded,
                            color: kPrimaryButtonColor,
                            size: 80,
                          )),
                IconButton(
                    onPressed: _resetTimer,
                    icon: Icon(
                      Icons.motion_photos_pause,
                      color: kPrimaryButtonColor,
                      size: 80,
                    )),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
