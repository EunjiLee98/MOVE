import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/services.dart';

class Dumbbell extends StatefulWidget {
  final List? data;

  Dumbbell({
    required this.data,
  });

  @override
  _DumbbellState createState() => _DumbbellState();
}

class Vector {
  double x, y;

  Vector(this.x, this.y);
}

class _DumbbellState extends State<Dumbbell> {
  double?
      leftShoulderX,
      leftShoulderY,
      rightShoulderX,
      rightShoulderY,
      leftElbowX,
      leftElbowY,
      rightElbowX,
      rightElbowY,
      leftWristX,
      leftWristY,
      rightWristX,
      rightWristY;

  var leftShoulderPos = Vector(0, 0);
  var rightShoulderPos = Vector(0, 0);
  var leftElbowPos = Vector(0, 0);
  var rightElbowPos = Vector(0, 0);
  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);

  List<String> bodyWeight = [
    'Coral test',
  ];

  bool? wristAlignment, shoulderAlignment, ankleAlignment, kneeAndHipAlignment;
  List<dynamic>? dynamicList;
  List? dataList;
  Map<String, List<double>>? inputArr;
  int? _counter;
  double? lowerRange, upperRange;
  bool? midCount, isCorrectPosture;
  double leftStart = 0;

  bool get isPlaying => _controller?.isActive ?? false;

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

  void _countingLogic(double left_y){
    if (left_y > leftStart) {
      setState(() {
        leftStart = left_y;

        if (_progress!.value != 100) {
          _progress!.value = (250 - leftStart) / 2;
        }
      });
    }

    if (left_y < leftStart) {
      setState(() {
        leftStart = left_y;

        _progress!.value = (250 - leftStart) / 2;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    String string_element = "";
    String key = "";
    double x = 0;
    double y = 0;
    double left_x = 0;
    double left_y = 0;
    double right_x = 0;
    double right_y = 0;
    var dictionary = new SplayTreeMap();
    var element1 = new SplayTreeMap();

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
          if (key == '9') {
            left_x = x;
            left_y = y;
          } else if (key == '10') {
            right_x = x;
            right_y = y;
          }
          print(
              "left_x : $left_x left_y : $left_y right_x : $right_x right_y : $right_y");

          dictionary.addAll({
            key: {"x": x, "y": y}
          });
        }
      }
    });
    print('dictionary: $dictionary');

    List<Widget> lists = <Widget>[];
    // Widget ? list;
    List<Widget> _renderKeypoints() {
      dictionary.forEach((key, value) {
        var _x = value["x"];
        var _y = value["y"];
        Widget list = Positioned(
          left: _x * 0.6,
          top: (_y + 50) / 0.8,
          width: 100,
          height: 15,
          child: Container(
            child: Text(
              "●",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        );
        lists.add(list);
      });
      _countingLogic(left_y);

      return lists;
    }

    return Stack(
      children: <Widget>[
        Container(
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
        Stack(
          children: _renderKeypoints(),
        )
      ],
    );
  }
}
