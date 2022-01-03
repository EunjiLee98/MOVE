import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Warrior extends StatefulWidget {
  final List<dynamic>? data;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  Warrior(
      {required this.data, required this.previewH, required this.previewW, required this.screenH, required this.screenW});
  @override
  _WarriorState createState() => _WarriorState();
}

class _WarriorState extends State<Warrior> {
  Map<String, List<double>>? inputArr;

  String excercise = 'warrior';
  Color? correctColor;
  Color? armColor, shoulderColor, legColor;
  String memo = 'Warrior position not aligned.';
  FlutterTts ? flutterTts;

  double? leftShoulderY,
      rightShoulderY,
      leftShoulderX,
      rightShoulderX,
      leftWristX,
      leftWristY,
      rightWristX,
      rightWristY,
      leftAnkleX,
      rightAnkleX,
      leftKneeY,
      leftHipY;

  bool? wristAlignment, shoulderAlignment, ankleAlignment, kneeAndHipAlignment;

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
    inputArr = new Map();
    correctColor = Colors.red;
    wristAlignment = false;
    shoulderAlignment = false;
    ankleAlignment = false;
    kneeAndHipAlignment = false;
    armColor = Colors.red;
    shoulderColor = Colors.red;
    legColor = Colors.red;
    flutterTts = new FlutterTts();
    flutterTts!.setSpeechRate(0.4);
    flutterTts!.speak("양 팔을 머리 위로 올려 손바닥을 붙여주시고, 한쪽 다리를 앞으로 내밀어주신 뒤, 반대쪽 다리를 뒤로 쭉 빼주세요");
    super.initState();
  }

  void _postureAccordingToExercise(Map<String, List<double>> poses) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    setState(() {
      // leftShoulderY = poses['left_shoulder']![1];
      // rightShoulderY = poses['right_shoulder']![1];
      // leftShoulderX = poses['left_shoulder']![0];
      // rightShoulderX = poses['right_shoulder']![0];
      // leftWristX = poses['left_wrist']![0];
      // leftWristY = poses['left_wrist']![1];
      // rightWristX = poses['right_wrist']![0];
      // rightWristY = poses['left_wrist']![1];
      // leftAnkleX = poses['left_ankle']![0];
      // rightAnkleX = poses['right_ankle']![0];
      // leftKneeY = poses['left_knee']![1];
      // leftHipY = poses['left_hip']![1];

      // leftShoulderY = poses['LEFT_SHOULDER']![1];
      // rightShoulderY = poses['RIGHT_SHOULDER']![1];
      // leftShoulderX = poses['LEFT_SHOULDER']![0];
      // rightShoulderX = poses['RIGHT_SHOULDER']![0];
      // leftWristX = poses['LEFT_WRIST']![0];
      // leftWristY = poses['LEFT_WRIST']![1];
      // rightWristX = poses['RIGHT_WRIST']![0];
      // rightWristY = poses['LEFT_WRIST']![1];
      // leftAnkleX = poses['LEFT_ANKLE']![0];
      // rightAnkleX = poses['RIGHT_ANKLE']![0];
      // leftKneeY = poses['LEFT_KNEE']![1];
      // leftHipY = poses['LEFT_HIP']![1];

      leftShoulderY = poses['leftShoulder']![1];
      rightShoulderY = poses['rightShoulder']![1];
      leftShoulderX = poses['leftShoulder']![0];
      rightShoulderX = poses['rightShoulder']![0];
      leftWristX = poses['leftWrist']![0];
      leftWristY = poses['leftWrist']![1];
      rightWristX = poses['rightWrist']![0];
      rightWristY = poses['leftWrist']![1];
      leftAnkleX = poses['leftAnkle']![0];
      rightAnkleX = poses['rightAnkle']![0];
      leftKneeY = poses['leftKnee']![1];
      leftHipY = poses['leftHip']![1];
    });

    if (leftWristX! - rightWristX! < leftShoulderX! - rightShoulderX! &&
        leftWristY! < h/3 &&
        rightWristY! < h/3) {
      wristAlignment = true;
      setState(() {
        armColor = Colors.green;
        shoulderColor = Colors.green;
      });
    } else {
      wristAlignment = false;
      setState(() {
        armColor = Colors.red;
        shoulderColor = Colors.red;
      });
    }
    if (leftAnkleX! - rightAnkleX! > leftShoulderX! - rightShoulderX!) {
      ankleAlignment = true;
      setState(() {
        legColor = Colors.green;
      });
    } else {
      ankleAlignment = false;
      setState(() {
        legColor = Colors.red;
      });
    }
    // if (leftKneeY! > w/3*2 && leftHipY! > w/2) {
    //   kneeAndHipAlignment = true;
    //   setState(() {
    //     //legColor = Colors.green;
    //   });
    // } else {
    //   kneeAndHipAlignment = false;
    //   setState(() {
    //     legColor = Colors.red;
    //   });
    // }
    // && kneeAndHipAlignment!
    if (wristAlignment! && ankleAlignment!) {
      setState(() {
        correctColor = Colors.green;
        memo = 'Warrior position aligned!';
      });
    } else {
      setState(() {
        correctColor = Colors.red;
        memo = 'Warrior position not aligned.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _getKeyPoints(k, x, y) {
      if (k["part"] == 'leftEye') {
        leftEyePos.x = x - 300;
        leftEyePos.y = y - 45;
      }
      if (k["part"] == 'rightEye') {
        rightEyePos.x = x - 300;
        rightEyePos.y = y - 45;
      }
      if (k["part"] == 'leftShoulder') {
        leftShoulderPos.x = x - 300;
        leftShoulderPos.y = y - 45;
      }
      if (k["part"] == 'rightShoulder') {
        rightShoulderPos.x = x - 300;
        rightShoulderPos.y = y - 45;
      }
      if (k["part"] == 'leftElbow') {
        leftElbowPos.x = x - 300;
        leftElbowPos.y = y - 45;
      }
      if (k["part"] == 'rightElbow') {
        rightElbowPos.x = x - 300;
        rightElbowPos.y = y - 45;
      }
      if (k["part"] == 'leftWrist') {
        leftWristPos.x = x - 300;
        leftWristPos.y = y - 45;
      }
      if (k["part"] == 'rightWrist') {
        rightWristPos.x = x - 300;
        rightWristPos.y = y - 45;
      }
      if (k["part"] == 'leftHip') {
        leftHipPos.x = x - 300;
        leftHipPos.y = y - 45;
      }
      if (k["part"] == 'rightHip') {
        rightHipPos.x = x - 300;
        rightHipPos.y = y - 45;
      }
      if (k["part"] == 'leftKnee') {
        leftKneePos.x = x - 300;
        leftKneePos.y = y - 45;
      }
      if (k["part"] == 'rightKnee') {
        rightKneePos.x = x - 300;
        rightKneePos.y = y - 45;
      }
      if (k["part"] == 'leftAnkle') {
        leftAnklePos.x = x - 300;
        leftAnklePos.y = y - 45;
      }
      if (k["part"] == 'rightAnkle') {
        rightAnklePos.x = x - 300;
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
              // child: Text(
              //   "● ${k["part"]}",
              //   style: TextStyle(
              //     color: Color.fromRGBO(37, 213, 253, 1.0),
              //     fontSize: 12.0,
              //   ),
              // ),
            ),
          );
        }).toList();

        _postureAccordingToExercise(inputArr!);
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
              painter: MyPainter(
                  left: leftShoulderPos,
                  right: rightShoulderPos,
                  color: shoulderColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: leftElbowPos, right: leftShoulderPos, color: armColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: leftWristPos, right: leftElbowPos, color: armColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: rightElbowPos,
                  right: rightShoulderPos,
                  color: armColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: rightWristPos, right: rightElbowPos, color: armColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: leftShoulderPos,
                  right: leftHipPos,
                  color: shoulderColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: leftHipPos, right: leftKneePos, color: legColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: leftKneePos, right: leftAnklePos, color: legColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: rightShoulderPos,
                  right: rightHipPos,
                  color: shoulderColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: rightHipPos, right: rightKneePos, color: legColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: rightKneePos, right: rightAnklePos, color: legColor),
            ),
            CustomPaint(
              painter: MyPainter(
                  left: leftHipPos, right: rightHipPos, color: shoulderColor),
            ),
          ],
        ),
        Stack(children: _renderKeypoints()),
      ],
    );
  }
}

class Vector {
  double x, y;
  Vector(this.x, this.y);
}

class MyPainter extends CustomPainter {
  Vector? left;
  Vector? right;
  Color? color;
  MyPainter({this.left, this.right, this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(left!.x, left!.y);
    final p2 = Offset(right!.x, right!.y);
    final paint = Paint()
      ..color = color! //Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
