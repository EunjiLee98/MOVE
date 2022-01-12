import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;

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
      leftWristX,
      leftWristY,
      rightWristX,
      rightWristY;

  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);

  List<String> bodyWeight = [
    'Coral test',
  ];

  bool? wristAlignment;
  List<dynamic>? dynamicList;
  List? dataList;
  Map<String, List<double>>? inputArr;
  int? _counter;
  double? lowerRange, upperRange;
  bool? midCount, isCorrectPosture;
  rive.Artboard? _riveArtboard;
  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _progress;

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
          left: _x - 175,
          top: _y - 50,
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
        children: _renderKeypoints());
  }
}