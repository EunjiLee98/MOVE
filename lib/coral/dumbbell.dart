import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
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