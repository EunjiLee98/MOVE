import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class SquatPage extends StatefulWidget {
  final List<dynamic> ? data;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  SquatPage({
    required this.data,
    required this.previewH,
    required this.previewW,
    required this.screenH,
    required this.screenW,
  });

  @override
  _SquatPageState createState() => _SquatPageState();

}

class Vector {
  double x, y;
  Vector(this.x, this.y);
}

class _SquatPageState extends State<SquatPage> {

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

  List<String>  bodyWeight= [
    'Squats',
  ];

  Map<String, List<double>> ? inputArr;
  int ? _counter;
  FlutterTts ? flutterTts;
  double ? lowerRange, upperRange;
  bool ? midCount,isCorrectPosture;

  late AudioPlayer player = AudioPlayer();

  Future<void> bgmPlay() async {
    await player.setAsset('assets/audio/bgm_ex.mp3');
    player.setLoopMode(LoopMode.one);
    player.play();
  }

  void setRangeBasedOnModel(){
    upperRange=300;
    lowerRange=500;
  }
  @override
  void initState() {
    super.initState();
    inputArr=new Map();
    _counter=0;
    midCount=false;
    isCorrectPosture=false;
    setRangeBasedOnModel();
    flutterTts = new FlutterTts();
    flutterTts!.setSpeechRate(0.4);
    flutterTts!.speak("다리를 어깨너비로 벌려 준비자세를 취해주세요");
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

  Positioned _createPositionedBlobs(double x, double y) {
    return Positioned(
      height: 5,
      width: 40,
      left:x,
      top:y,
      child: Container(
        color: getCounterColor(),
      ),
    );
  }

  List<Widget>  _renderHelperBlobs() {
    List<Widget>  listToReturn = <Widget>[];
    listToReturn.add(_createPositionedBlobs(0, upperRange!));
    listToReturn.add(_createPositionedBlobs(0, lowerRange!));
    return listToReturn;
  }

  //region Core
  _postureAccordingToExercise(Map<String, List<double>> poses){
    // if(widget.customModel==bodyWeight[1]) {
    //   return poses['leftShoulder']![1] < upperRange!
    //       && poses['rightShoulder']![1] < upperRange!;
    // }
    //if(widget.customModel==bodyWeight[0]) {
    return poses['leftShoulder']![1] < upperRange!
        && poses['rightShoulder']![1] < upperRange!
        && poses['rightKnee']![1] > lowerRange!
        && poses['leftKnee']![1] > lowerRange!;
    //}
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if(_postureAccordingToExercise(poses)){
      if(!isCorrectPosture!){
        setState(() {
          isCorrectPosture=true;
        });
      }
    } else {
      if(isCorrectPosture!) {
        setState(() {
          isCorrectPosture = false;
        });
      }
    }
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (isCorrectPosture! && poses['leftShoulder']![1] > upperRange! && poses['rightShoulder']![1] > upperRange!) {
      setMidCount(true);
    }

    if (midCount! && poses['leftShoulder']![1] < upperRange! && poses['rightShoulder']![1] < upperRange!) {
      incrementCounter();
      setMidCount(false);
    }
    //check the posture when not in midcount
    if(!midCount!) {
      _checkCorrectPosture(poses);
    }
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.data!.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW > widget.previewH / widget.previewW) {
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

          inputArr![k['part']] = [x,y];

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
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
//            child: LinearPercentIndicator(
//              animation: true,
//              lineHeight: 20.0,
//              animationDuration: 500,
//              animateFromLastPercent: true,
//              percent: _counter,
//              center: Text("${(_counter).toStringAsFixed(1)}"),
//              linearStrokeCap: LinearStrokeCap.roundAll,
//              progressColor: Colors.green,
//            ),
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
