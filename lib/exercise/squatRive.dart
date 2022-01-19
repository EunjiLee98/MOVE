import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/reabilitation/camera.dart';
import 'package:move/theme/font.dart';
import 'package:rive/rive.dart' as rive;
import 'package:tflite/tflite.dart';

import 'finish_exercise.dart';

/// An example showing how to drive a StateMachine via a trigger and number
/// input.
class Squat extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  final String title;

  Squat({required this.cameras, this.bluetoothServices, required this.title});

  @override
  _SquatState createState() => _SquatState();
}

class _SquatState extends State<Squat> {
  List<dynamic>? _data;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int x = 1;

  @override
  void initState() {
    super.initState();
    var res = loadModel();
    print('Model Response: ' + res.toString());
  }

  _setRecognitions(data, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _data = data;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadModel() async {
    return await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          SquatData(
            data: _data ?? [],
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
            bluetoothServices: widget.bluetoothServices,
            cameras: widget.cameras,
          ),
          Positioned(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                      child: whiteRusso('Squat', 20, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Camera(
                cameras: widget.cameras!,
                setRecognitions: _setRecognitions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SquatData extends StatefulWidget {
  final List<dynamic> data;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;

  SquatData({
    required this.data,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
    this.bluetoothServices,
    this.cameras
  });

  @override
  _SquatDataState createState() => _SquatDataState();
}

class _SquatDataState extends State<SquatData> {
  double? leftShoulderY,
      rightShoulderY,
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

  Map<String, List<double>>? inputArr;
  int? _counter;
  double? lowerRange, upperRange;
  bool? midCount, isCorrectPosture;

  // Rive state management test
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  rive.Artboard? _riveArtboard;
  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _progress;

  double leftStart = 0;

  void setRangeBasedOnModel() {
    upperRange = 300;
    lowerRange = 500;
  }

  @override
  void initState() {
    super.initState();
    inputArr = new Map();
    _counter = 0;
    midCount = false;
    isCorrectPosture = false;
    setRangeBasedOnModel();

    rootBundle.load('assets/rive/move_squat.riv').then(
      (data) async {
        final file = rive.RiveFile.import(data);

        final artboard = file.mainArtboard;
        var controller = rive.StateMachineController.fromArtboard(
            artboard, 'Squat_Controller');
        if (controller != null) {
          artboard.addController(controller);
          _progress = controller.findInput('Progress');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  void resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void incrementCounter() {
    setState(() {
      if (_counter != null) {
        _counter = _counter! + 1;

        if(_counter == 3) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>
                FinishExercise(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras, name: 'Squat',)), (route) => false);
          });
        }
      }
    });
  }

  void setMidCount(bool f) {
    setState(() {
      midCount = f;
    });
  }

  Color getCounterColor() {
    if (isCorrectPosture!) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Positioned _createPositionedBlobs(double x, double y) {
    return Positioned(
      height: 5,
      width: 40,
      left: x,
      top: y,
      child: Container(
        color: getCounterColor(),
      ),
    );
  }

  List<Widget> _renderHelperBlobs() {
    List<Widget> listToReturn = <Widget>[];
    listToReturn.add(_createPositionedBlobs(0, upperRange!));
    listToReturn.add(_createPositionedBlobs(0, lowerRange!));
    return listToReturn;
  }

  //region Core
  _postureAccordingToExercise(Map<String, List<double>> poses) {
    // if(widget.customModel==bodyWeight[1]) {
    //   return poses['leftShoulder']![1] < upperRange!
    //       && poses['rightShoulder']![1] < upperRange!;
    // }
    //if(widget.customModel==bodyWeight[0]) {
    return poses['leftShoulder']![1] < upperRange! &&
        poses['rightShoulder']![1] < upperRange! &&
        poses['rightKnee']![1] > lowerRange! &&
        poses['leftKnee']![1] > lowerRange!;
    //}
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)) {
      if (!isCorrectPosture!) {
        setState(() {
          isCorrectPosture = true;
          leftStart = poses['leftShoulder']![1];
        });
      }
    } else {
      if (isCorrectPosture!) {
        setState(() {
          isCorrectPosture = false;
        });
      }
    }
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (isCorrectPosture! &&
        poses['leftShoulder']![1] > upperRange! &&
        poses['rightShoulder']![1] > upperRange!) {
      setMidCount(true);
    }

    if (midCount! &&
        poses['leftShoulder']![1] < upperRange! &&
        poses['rightShoulder']![1] < upperRange!) {
      incrementCounter();
      setMidCount(false);
      setState(() {
        // _squatController.isActive = true;
        // _controller.isActive = false;
      });
    }
    //check the posture when not in midcount
    if (!midCount!) {
      _checkCorrectPosture(poses);
    }

    if (poses['leftShoulder']![1] > leftStart) {
      setState(() {
        leftStart = poses['leftShoulder']![1];

        if (_progress!.value != 100) {
          _progress!.value = (leftStart - 300) / 2;
        }
      });
    }

    if (poses['leftShoulder']![1] < leftStart) {
      setState(() {
        leftStart = poses['leftShoulder']![1];

        _progress!.value = (leftStart - 300) / 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.data.forEach((re) {
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

          // To solve mirror problem on front camera
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }
          return Positioned(
            left: x - 275,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
                // child: Text(
                //   "●",
                //   style: TextStyle(
                //     color: Color.fromRGBO(37, 213, 253, 1.0),
                //     fontSize: 12.0,
                //   ),
                // ),
                ),
          );
        }).toList();

        _countingLogic(inputArr!);

        inputArr!.clear();
        lists..addAll(list);
      });
      return lists;
    }

    return Stack(
      children: <Widget>[
        Stack(
          children: _renderHelperBlobs(),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff37384E), const Color(0xff53304C)],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: rive.Rive(
                    artboard: _riveArtboard!,
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: 60,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset('time.png', width: 70,),
                      // Container(
                      //     decoration: BoxDecoration(
                      //         color: Color(0xff290055),
                      //         borderRadius: BorderRadius.circular(8)
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Column(
                      //         children: [
                      //           whiteNoto('진행시간', 12, true),
                      //         ],
                      //       ),
                      //     )
                      // )
                    ],
                  ),
                  SizedBox(width: 10,),
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('score.png')
                          )
                        ),
                        child: Center(child: navyRusso('${_counter.toString()}', 60, true)),
                      ),
                    ],
                  ),
                  SizedBox(width: 10,),
                  whiteRusso('/ 3', 30, false)
                ],
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: whiteNoto(isCorrectPosture! ? '준비완료!' : '몸을 카메라에 맞게 다시', 14, true),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 5,
                            color: Colors.white.withOpacity(0.5)
                          ),
                          borderRadius: BorderRadius.circular(78),
                          color: getCounterColor()
                        ),
                      )
                    ],
                  )
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: _renderKeypoints(),
        ),
      ],
    );
  }
}

class Vector {
  double x, y;

  Vector(this.x, this.y);
}
