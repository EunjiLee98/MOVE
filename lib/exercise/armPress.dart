import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/reabilitation/camera.dart';
import 'package:rive/rive.dart' as rive;
import 'package:tflite/tflite.dart';

class ArmPress extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;

  ArmPress({required this.cameras, required this.title});

  @override
  _ArmPressState createState() => _ArmPressState();
}

class _ArmPressState extends State<ArmPress> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MOVE! - Dumbbell Rive',
          style: GoogleFonts.russoOne(
            fontSize: 25,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          ArmPressData(
            data: _data ?? [],
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
          ),
          // Positioned(
          //   right: 0,
          //   bottom: 0,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.25,
          //     height: MediaQuery.of(context).size.height * 0.25,
          //     child: Camera(
          //       cameras: widget.cameras,
          //       setRecognitions: _setRecognitions,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ArmPressData extends StatefulWidget {
  final List<dynamic> data;
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

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/rive/move_dumbbell.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        final file = rive.RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller = rive.StateMachineController.fromArtboard(
            artboard, 'Dumbbell_Controller');
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
      if (_counter != null) _counter = _counter! + 1;
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

  //endregion

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
              child: Text(
                "●",
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
      return lists;
    }

    return Stack(children: <Widget>[
      Stack(
        children: _renderHelperBlobs(),
      ),
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [const Color(0xff37384E), const Color(0xff53304C)],
      //     ),
      //   ),
      // ),
      // Container(
      //   height: MediaQuery.of(context).size.height,
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: rive.Rive(
      //           artboard: _riveArtboard!,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
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
      Stack(
        children: _renderKeypoints(),
      ),
    ]);
  }
}

class Vector {
  double x, y;

  Vector(this.x, this.y);
}