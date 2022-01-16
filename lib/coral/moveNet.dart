import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/services.dart';

class MoveNet extends StatefulWidget {
  final List? data;

  MoveNet({
    required this.data,
  });

  @override
  _MoveNetState createState() => _MoveNetState();
}

class Vector {
  double x, y;

  Vector(this.x, this.y);
}

class _MoveNetState extends State<MoveNet> {
  double? noseX,
      noseY, //0
      leftEyeX,
      leftEyeY, //1
      rightEyeX,
      rightEyeY, //2
      leftEarX,
      leftEarY, //3
      rightEarX,
      rightEarY, //4
      leftShoulderX,
      leftShoulderY, //5
      rightShoulderX,
      rightShoulderY, //6
      leftElbowX,
      leftElbowY, //7
      rightElbowX,
      rightElbowY, //8
      leftWristX,
      leftWristY, //9
      rightWristX,
      rightWristY, //10
      leftHipX,
      leftHipY, //11
      rightHipX,
      rightHipY, //12
      leftKneeX,
      leftKneeY, //13
      rightKneeX,
      rightKneeY, //14
      leftAnkleX,
      leftAnkleY, //15
      rightAnkleX,
      rightAnkleY; //16

  var leftEyePos = Vector(0, 0);
  var rightEyePos = Vector(0, 0);
  var leftEarPos = Vector(0, 0);
  var rightEarPos = Vector(0, 0);
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

  List<String> bodyWeight = [
    'Coral test',
  ];

  bool? wristAlignment, shoulderAlignment, ankleAlignment, kneeAndHipAlignment;
  List<dynamic>? dynamicList;
  List? dataList;
  Map<String, List<double>>? inputArr;
  double? lowerRange, upperRange;
  bool? midCount, isCorrectPosture;
  late AudioPlayer player = AudioPlayer();

  rive.Artboard? _riveArtboard;
  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();
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

  List makeList(String data) {
    List temp;
    temp = data.split(" ");
    return temp;
  }

  List<dynamic> makeDynamicList(List dataList) {
    var jsonDynamic;
    jsonDynamic = List<dynamic>.from(dataList);
    return jsonDynamic;
  }


  @override
  Widget build(BuildContext context) {
    String string_element = "";
    String key = "";
    double x = 0;
    double y = 0;
    var dictionary = new SplayTreeMap();
    var element1 = new SplayTreeMap();
    // double left_x = 0;
    // double left_y = 0;
    // double right_x = 0;
    // double right_y = 0;


    widget.data!.forEach((element) {
      string_element = element.toString().replaceAll('"', '');
      dataList = string_element.split(" ");
      if (dataList!.isEmpty) {
        dictionary.clear();
        element1.clear();
      } else if (dataList!.isNotEmpty) {
        for (int i = 0; i < dataList!.length - 1; i++) {
          key = dataList![0].toString().substring(13);
          x = double.parse(dataList![1]);
          y = double.parse(dataList![2]);
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }


          // if (key == "9"){
          //   left_x = x;
          //   left_y = y;
          // }
          // else if (key == "10"){
          //   right_x = x;
          //   right_y = y;
          // }
          // if (left_x < 200){
          //   count = count + 1;
          //   print(count);
          // }

          // print(left_x);
          // print(left_y);
          // print(right_x);
          // print(right_y);
          dictionary.addAll({
            key: {"x": x, "y": y}
          });
        }
      }
    });
    print('dictionary: $dictionary');

    List<Widget> lists = <Widget>[];
    List<Widget> _renderKeypoints() {
      dictionary.forEach((key, value) {
        var _x = value["x"];
        var _y = value["y"];
        Widget list = Positioned(
            left: _x * 0.6,
            top: _y ,
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
        lists.add(list);
      });
      return lists;
    }

    return Stack(
      children: _renderKeypoints(),
    );
  }
}
