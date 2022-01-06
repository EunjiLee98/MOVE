import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class ArmPressData extends StatefulWidget {
  final List<dynamic> ? data;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  ArmPressData(
      {required this.data, required this.previewH, required this.previewW, required this.screenH, required this.screenW});
  @override
  _ArmPressDataState createState() => _ArmPressDataState();
}

class _ArmPressDataState extends State<ArmPressData> {
  Map<String, List<double>>  ? inputArr;
  FlutterTts ? flutterTts;

  String excercise = 'arm_press';
  double upperRange = 300;
  double lowerRange = 500;
  bool ? midCount, isCorrectPosture;
  int ? _counter;
  Color ? correctColor;
  double ? shoulderLY;
  double ? shoulderRY;

  double ? wristLX, wristLY, wristRX, wristRY, elbowLX, elbowRX;
  double ? kneeRY;
  double ? kneeLY;
  bool ? squatUp;
  String whatToDo = 'Finding Posture';

  var leftEyePos = Vector(0, 0);
  var rightEyePos = Vector(0, 0);
  var leftShoulderPos = Vector(0, 0);
  var rightShoulderPos = Vector(0, 0);
  var leftHipPos = Vector(0, 0);
  var rightHipPos = Vector(0, 0);
  var leftElbowPos = Vector(0, 0);
  var rightElbowPos = Vector(0, 0);
  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);
  var leftKneePos = Vector(0, 0);
  var rightKneePos = Vector(0, 0);
  var leftAnklePos = Vector(0, 0);
  var rightAnklePos = Vector(0, 0);

  @override
  void initState() {
    super.initState();
    inputArr = new Map();
    midCount = false;
    isCorrectPosture = false;
    _counter = 0;
    correctColor = Colors.red;
    shoulderLY = 0;
    shoulderRY = 0;
    kneeRY = 0;
    kneeLY = 0;
    squatUp = true;
    flutterTts = new FlutterTts();
    flutterTts!.setSpeechRate(0.4);
    flutterTts!.speak("두 팔을 어깨와 일직선이 되도록 벌려서 준비 자세를 취해주세요");
  }

  bool ? _postureAccordingToExercise(Map<String, List<double>> poses) {
    setState(() {
      wristLX = poses['leftWrist']![0];
      wristLY = poses['leftWrist']![1];
      wristRX = poses['rightWrist']![0];
      wristRY = poses['rightWrist']![1];
      elbowLX = poses['leftElbow']![0];
      elbowRX = poses['rightElbow']![0];

      shoulderLY = poses['leftShoulder']![1];
      shoulderRY = poses['rightShoulder']![1];
      kneeLY = poses['leftKnee']![1];
      kneeRY = poses['rightKnee']![1];
    });
    if (excercise == 'arm_press') {
      if (squatUp!) {
        return wristLX! > 280 &&
            elbowLX! > 280 &&
            wristRX! < 95 &&
            elbowRX! < 95 &&
            wristLY! < 240 &&
            wristLY! > 200 &&
            wristRY! < 240 &&
            wristRY! > 200;
      } else {
        return wristLY! < 125 && wristRY! < 125;
      }
    }
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)!) {
      if (!isCorrectPosture!) {
        setState(() {
          isCorrectPosture = true;
          correctColor = Colors.green;
        });
      }
    } else {
      if (isCorrectPosture!) {
        setState(() {
          isCorrectPosture = false;
          correctColor = Colors.red;
        });
      }
    }
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      _checkCorrectPosture(poses);

      if (isCorrectPosture! && squatUp! && midCount == false) {
        //in correct initial posture
        setState(() {
          flutterTts!.speak("lift");
          //correctColor = Colors.green;
        });
        squatUp = !squatUp!;
        isCorrectPosture = false;
      }

      //lowered all the way
      if (isCorrectPosture! && !squatUp! && midCount == false) {
        midCount = true;
        isCorrectPosture = false;
        squatUp = !squatUp!;
        setState(() {
          flutterTts!.speak("drop");
          //correctColor = Colors.green;
        });
      }

      //back up
      if (midCount! && isCorrectPosture!) {
        incrementCounter();
        midCount = false;
        squatUp = !squatUp!;
        setState(() {
          whatToDo = 'Lift';
        });
      }
    }
  }

  void resetCounter() {
    setState(() {
      _counter = 0;
    });
    flutterTts!.speak("운동이 초기화되었습니다");
  }

  void incrementCounter() {
    setState(() {
      if (_counter!=null)
        _counter = _counter! + 1;
    });
    flutterTts!.speak(_counter.toString());
  }

  void setMidCount(bool f) {
    //when midcount is activated
    if(f && !midCount!) {
      flutterTts!.speak("잘했습니다!");
    }
    setState(() {
      midCount = f;
    });
  }

  Color getCounterColor() {
    if(isCorrectPosture!) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _getKeyPoints(k, x, y) {
      if (k["part"] == 'leftEye') {
        leftEyePos.x = x - 230;
        leftEyePos.y = y - 45;
      }
      if (k["part"] == 'rightEye') {
        rightEyePos.x = x - 230;
        rightEyePos.y = y - 45;
      }
      if (k["part"] == 'leftShoulder') {
        leftShoulderPos.x = x - 230;
        leftShoulderPos.y = y - 45;
      }
      if (k["part"] == 'rightShoulder') {
        rightShoulderPos.x = x - 230;
        rightShoulderPos.y = y - 45;
      }
      if (k["part"] == 'leftElbow') {
        leftElbowPos.x = x - 230;
        leftElbowPos.y = y - 45;
      }
      if (k["part"] == 'rightElbow') {
        rightElbowPos.x = x - 230;
        rightElbowPos.y = y - 45;
      }
      if (k["part"] == 'leftWrist') {
        leftWristPos.x = x - 230;
        leftWristPos.y = y - 45;
      }
      if (k["part"] == 'rightWrist') {
        rightWristPos.x = x - 230;
        rightWristPos.y = y - 45;
      }
      if (k["part"] == 'leftHip') {
        leftHipPos.x = x - 230;
        leftHipPos.y = y - 45;
      }
      if (k["part"] == 'rightHip') {
        rightHipPos.x = x - 230;
        rightHipPos.y = y - 45;
      }
      if (k["part"] == 'leftKnee') {
        leftKneePos.x = x - 230;
        leftKneePos.y = y - 45;
      }
      if (k["part"] == 'rightKnee') {
        rightKneePos.x = x - 230;
        rightKneePos.y = y - 45;
      }
      if (k["part"] == 'leftAnkle') {
        leftAnklePos.x = x - 230;
        leftAnklePos.y = y - 45;
      }
      if (k["part"] == 'rightAnkle') {
        rightAnklePos.x = x - 230;
        rightAnklePos.y = y - 45;
      }
    }

    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.data!.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          inputArr![k['part']] = [x, y];
          //Mirroring
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }

          _getKeyPoints(k, x, y);

          if (k["part"] == 'leftEye') {
            leftEyePos.x = x - 230;
            leftEyePos.y = y - 45;
          }
          if (k["part"] == 'rightEye') {
            rightEyePos.x = x - 230;
            rightEyePos.y = y - 45;
          }
          return Positioned(
            left: x - 230,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
              child: Text(
                "● ${k["part"]}",
                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 12.0,
                ),
              ),
            ),
          );
        }).toList();

        _countingLogic(inputArr!);
        inputArr!.clear();

        lists..addAll(list);
      });
      //lists.clear();

      return lists;
    }

    return Stack(
      children: <Widget>[
        Stack(
          children: [
            CustomPaint(
              painter:
              MyPainter(left: leftShoulderPos, right: rightShoulderPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftElbowPos, right: leftShoulderPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftWristPos, right: leftElbowPos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightElbowPos, right: rightShoulderPos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightWristPos, right: rightElbowPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftShoulderPos, right: leftHipPos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftHipPos, right: leftKneePos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftKneePos, right: leftAnklePos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightShoulderPos, right: rightHipPos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightHipPos, right: rightKneePos),
            ),
            CustomPaint(
              painter: MyPainter(left: rightKneePos, right: rightAnklePos),
            ),
            CustomPaint(
              painter: MyPainter(left: leftHipPos, right: rightHipPos),
            ),
          ],
        ),
        Stack(children: _renderKeypoints()),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Align(
              alignment: Alignment.center,
              // child: Container(
              //   height: 50,
              //   width: widget.screenW,
              //   decoration: BoxDecoration(
              //     color: correctColor,
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(25.0),
              //         topRight: Radius.circular(25)),
              //   ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Container(
                    height: 100,
                    width: 100,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: getCounterColor(),
                        onPressed: resetCounter,
                        child: Text(
                          '${_counter.toString()}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class Vector {
  double x, y;
  Vector(this.x, this.y);
}

class MyPainter extends CustomPainter {
  Vector left;
  Vector right;
  MyPainter({required this.left, required this.right});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(left.x, left.y);
    final p2 = Offset(right.x, right.y);
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}