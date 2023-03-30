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
  Timer? _timer;
  TextEditingController hourController = TextEditingController();
  TextEditingController minController = TextEditingController();

  void _startTimer() {
    setState(() {
      _totalSeconds = _hours + _min;
      _isPaused = false;
      _secondsRemaining = _totalSeconds;
      _saveTotalSeconds();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isPaused = true;
          timer.cancel();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
      _timer?.cancel();
    });
  }

  void _resetTimer() {
    setState(() {
      _isPaused = true;
      _timer?.cancel();
      _totalSeconds = 0;
      _secondsRemaining = 0;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadTotalSeconds();
  }

  void _loadTotalSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _secondsRemaining = prefs.getInt('totalSeconds') ?? 0;
    });
  }
  void _saveTotalSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalSeconds', _secondsRemaining);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Focus Screen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isPaused ? _startTimer : _pauseTimer,
                  child: Text(_isPaused ? "Start" : "Pause"),
                ),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text("Reset"),
                ),

              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

}
