import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:move/coral/dumbbellRive_1pwin.dart';
import 'package:move/coral/dumbbellRive_2pwin.dart';
import 'package:move/theme/font.dart';
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
  double? leftShoulderX,
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
  int _counter1 = 9;
  int _counter2 = 0;
  double? lowerRange, upperRange;
  bool? midCount, isCorrectPosture;
  double leftStart = 0;

  bool get isPlaying => _controller?.isActive ?? false;

  bool get isPlaying1 => _controller1?.isActive ?? false;

  bool? flag;

  rive.Artboard? _riveArtboard1;
  rive.StateMachineController? _controller1;
  rive.SMIInput<double>? _progress1;

  rive.Artboard? _riveArtboard;
  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();
    resetCounter();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    rootBundle.load('assets/rive/move_dumbbell.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        final file = rive.RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.artboardByName('Dumbbell');
        var controller = rive.StateMachineController.fromArtboard(
            artboard!, 'Dumbbell_Controller');
        if (controller != null) {
          artboard.addController(controller);
          _progress = controller.findInput('Progress');
        }
        setState(() => _riveArtboard = artboard);
      },
    );

    rootBundle.load('assets/rive/move_dumbbell.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        final file1 = rive.RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard1 = file1.artboardByName('Dumbbell2');
        var controller1 = rive.StateMachineController.fromArtboard(
            artboard1!, 'Dumbbell_Controller');
        if (controller1 != null) {
          artboard1.addController(controller1);
          _progress1 = controller1.findInput('Progress');
        }
        setState(() => _riveArtboard1 = artboard1);
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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

  void setRangeBasedOnCoral() {
    upperRange = 300;
    lowerRange = 500;
  }

  void _countingLogic1(double left_y) {
    if (left_y > leftStart) {
      setState(() {
        leftStart = left_y;

        if (_progress!.value != 100) {
          _progress!.value = (250 * 9 / 16 - leftStart) * 0.6;
          print("progress value : " + _progress!.value.toString());
        }

        if (_progress!.value > 80 * 9 / 16) {
          flag = true;
        }

        if (_progress!.value < 60 * 9 / 16 && flag == true) {
          incrementCounter1();
          flag = false;
        }
      });
    }

    if (left_y < leftStart) {
      setState(() {
        leftStart = left_y;
        _progress!.value = (250 * 9 / 16 - leftStart) * 0.6;
        print("progress value : " + _progress!.value.toString());
      });
    }
  }

  void _countingLogic2(double left_y) {
    if (left_y > leftStart) {
      setState(() {
        leftStart = left_y;

        if (_progress1!.value != 100) {
          _progress1!.value = (250 * 9 / 16 - leftStart) * 0.6;
          print("progress1 value : " + _progress1!.value.toString());
        }

        if (_progress1!.value > 80 * 9 / 16) {
          flag = true;
        }

        if (_progress1!.value < 60 * 9 / 16 && flag == true) {
          incrementCounter2();
          flag = false;
        }
      });
    }

    if (left_y < leftStart) {
      setState(() {
        leftStart = left_y;
        _progress1!.value = (250 * 9 / 16 - leftStart) * 0.6;
        print("progress value : " + _progress1!.value.toString());
      });
    }
  }

  void resetCounter() {
    setState(() {
      _counter1 = 0;
      _counter2 = 0;
    });
  }

  void incrementCounter1() {
    setState(() {
      _counter1 = _counter1 + 1;
      if (_counter1 == 10)
      {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DumbbellRive_1pwin(score_1p: _counter1, score_2p : _counter2)));
        });
      }

    });
  }

  void incrementCounter2() {
    setState(() {
      _counter2 = _counter2 + 1;
      if (_counter2 == 10)
      {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DumbbellRive_2pwin(score_1p: _counter1, score_2p : _counter2)));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String string_element = "";
    String key = "";
    double x = 0;
    double y = 0;
    double left_x1 = 0;
    double left_y1 = 0;
    double right_x1 = 0;
    double right_y1 = 0;
    double left_x2 = 0;
    double left_y2 = 0;
    double right_x2 = 0;
    double right_y2 = 0;
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
          if (key == '9' && x <= (MediaQuery.of(context).size.width / 4)) {
            left_x1 = x;
            left_y1 = y;
          } else if (key == '10' &&
              x <= (MediaQuery.of(context).size.width / 4)) {
            right_x1 = x;
            right_y1 = y;
          } else if (key == '9' &&
              x > (MediaQuery.of(context).size.width / 4)) {
            left_x2 = x;
            left_y2 = y;
          } else if (key == '10' &&
              x > (MediaQuery.of(context).size.width / 4)) {
            right_x2 = x;
            right_y2 = y;
          }
          print(
              "left_x1 : $left_x1 left_y1 : $left_y1 right_x1 : $right_x1 right_y1 : $right_y1");
          print(
              "left_x2 : $left_x2 left_y2 : $left_y2 right_x2 : $right_x2 right_y2 : $right_y2");

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
      _countingLogic1(left_y1);
      _countingLogic2(left_y2);

      return lists;
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('dumbbellRive_bg.png'), fit: BoxFit.fill)),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              //height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  //Player 1
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('dumbbellRive_count.png'),
                                  )),
                            ),
                            //backgroundColor: getCounterColor(),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 38),
                              child: navyRusso(
                                  '${_counter1.toString()}', 20, true),
                            ),
                          ],
                        ),
                        Expanded(
                          child: rive.Rive(
                            artboard: _riveArtboard!,
                          ),
                        ),
                        Container(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset('dumbbellRive_1p.png')),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('dumbbellRive_line.png'),
                            fit: BoxFit.fill)),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('dumbbellRive_vs.png'),
                    ),
                  ),
                  //Player 2
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('dumbbellRive_count.png'),
                                  )),
                            ),
                            //backgroundColor: getCounterColor(),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 38),
                              child: navyRusso(
                                  '${_counter1.toString()}', 20, true),
                            ),
                          ],
                        ),
                        Expanded(
                          child: rive.Rive(
                            artboard: _riveArtboard1!,
                          ),
                        ),
                        Container(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset('dumbbellRive_2p.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: _renderKeypoints(),
            )
          ],
        ),
      ),
    );
  }
}