import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class MoveNet extends StatefulWidget {
  final String ? data;

  MoveNet({
    required this.data,
  });

  @override
  _MoveNetState createState() => _MoveNetState();

}

class _MoveNetState extends State<MoveNet> {

  double?  noseX,
      noseY,
      leftEyeX,
      leftEyeY,
      rightEyeX,
      rightEyeY,
      leftEarX,
      leftEarY,
      rightEarX,
      rightEarY,
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
      rightWristY,
      leftHipX,
      leftHipY,
      rightHipX,
      rightHipY,
      leftKneeX,
      leftKneeY,
      rightKneeX,
      rightKneeY,
      leftAnkleX,
      leftAnkleY,
      rightAnkleX,
      rightAnkleY;

  // double setXY (List data)
  // {
  //   double x, y;
  //   int i = 0;
  //   int index;
  //   for (i = 0 ; i < data.length; i ++)
  //     {
  //       if (i % 3 == 0)
  //         index = i;
  //       else if (i % 2 == 0)
  //         y = data[i];
  //       else
  //         x = data[i];
  //     }
  //   return
  // }


  // var leftEyePos = Vector(0, 0);
  // var rightEyePos = Vector(0, 0);
  // var leftShoulderPos = Vector(0, 0);
  // var rightShoulderPos = Vector(0, 0);
  // var leftHipPos = Vector(0, 0);
  // var rightHipPos = Vector(0, 0);
  // var leftElbowPos = Vector(0, 0);
  // var rightElbowPos = Vector(0, 0);
  // var leftWristPos = Vector(0, 0);
  // var rightWristPos = Vector(0, 0);
  // var leftKneePos = Vector(0, 0);
  // var rightKneePos = Vector(0, 0);
  // var leftAnklePos = Vector(0, 0);
  // var rightAnklePos = Vector(0, 0);

  List<String>  bodyWeight= [
    'Coral test',
  ];

  bool? wristAlignment, shoulderAlignment, ankleAlignment, kneeAndHipAlignment;
  List<dynamic> ? dynamicList;
  List ? dataList;
  Map<String, List<double>> ? inputArr;
  int ? _counter;
  double ? lowerRange, upperRange;
  bool ? midCount,isCorrectPosture;
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    //dynamicList = makeDynamicList();
    setRangeBasedOnModel();
  }

  Future<void> bgmPlay() async {
    await player.setAsset('assets/audio/bgm_ex.mp3');
    player.setLoopMode(LoopMode.one);
    player.play();
  }

  void setRangeBasedOnModel(){
    upperRange=300;
    lowerRange=500;
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

  void resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void incrementCounter() {
    setState(() {
      if (_counter!=null)
        _counter = _counter! + 1;
    });
  }

  void setMidCount(bool f) {
    //when midcount is activated
    if(f && !midCount!) {
      //flutterTts!.speak("잘했습니다!");
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
    dataList = makeList(widget.data!);
    dynamicList = makeDynamicList(dataList!);

    // print("data : ");
    // print(widget.data);
    // List<Widget> _renderKeypoints() {
    //   var lists = <Widget>[];

    var _x = "";
    var _y = "";
    int x = 0;
    int y = 0;
    _renderKeypoints() {
      for (var value in dynamicList!) {
        //print(value);
        //var list = value.map<Widget>((k) {
        _x = dynamicList![1].toString();
        _y = dynamicList![2].toString();

        print(dynamicList![0] + " " + _x + " " + _y);

        x = int.parse(_x);
        y = int.parse(_y);

        // var scaleW, scaleH, x, y;

        Size screen = MediaQuery
            .of(context)
            .size;
        return Positioned(
          left: screen.width - x,
          top: screen.height - y,
          width: 100,
          height: 15,
          child: Expanded(
            child: Text(
              "●",
              style: TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 12.0,
              ),
            ),
          ),
        );
        // }).toList();

      }
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
        Column(
          children: [
            Center(),
            _renderKeypoints(),
          ],
        ),
      ]);
    }

}
