import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:move/reabilitation/test/utility.dart';
import 'dart:isolate';

import '../../main.dart';
import '../camera.dart';
import 'classifier.dart';
import 'exerciseList.dart';
import 'exercise_handler.dart';
import 'isolate.dart';
import 'package:rive/rive.dart' as rive;

class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  late Classifier classifier;
  late IsolateUtils isolate;

  bool predicting = false;
  bool initialized = false;
  late List parsedData;
  late List<dynamic> inferences;

  // TEST VARIABLES
  double test_angle1 = 0;
  double test_angle2 = 0;
  double test_angle3 = 0;

  // WORKOUT AND WEEK DATA
  late List<dynamic> exercise;
  late String workout;
  late var dayToday;

  // DAY WORKOUT VARIABLES
  late var handler;

  int workoutIndex = 0;
  String exerciseName = "";
  String exerciseDisplayName = "";
  int reps = 0;
  int sets = 0;

  int doneReps = 0;
  int doneSets = 0;
  var stage = "up";
  bool rest = false;
  int restTime = 0;

  // POSE AND FORM VALIDATION
  bool isProperForm = false;
  List<dynamic> limbs = [];
  List<dynamic> targets = [];

  bool get isPlaying => _controller?.isActive ?? false;

  rive.Artboard? _riveArtboard;
  rive.StateMachineController? _controller;
  rive.SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();
    initAsync();

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

  void initAsync() async {
    isolate = IsolateUtils();
    await isolate.start();
    classifier = Classifier();
    classifier.loadModel();
    loadCamera();
    getExerciseData(); //추가

    setState(() {
      limbs = handler.limbs;
      targets = handler.targets;
    });
  }

  void getExerciseData() {
    setState(() {
      exerciseName = "dumbell_curl";
      exerciseDisplayName = "Dumbell curl";
      reps = 3;
      sets = 3;
      handler = Exercises["dumbell_curl"]!.handler;
      handler.init();
      limbs = handler.limbs;
      targets = handler.targets;
    });
  }

  void nextWorkout() {
    setState(() {
      workoutIndex += 1;
    });
    getExerciseData();
  }

  void loadCamera() {
    setState(() {
      cameraController = CameraController(cameras![1], ResolutionPreset.medium);
    });
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        cameraController!.startImageStream((imageStream) {
          createIsolate(imageStream);
        });
      }
    });
  }

  void createIsolate(CameraImage imageStream) async {
    if (predicting == true) {
      return;
    }

    setState(() {
      predicting = true;
    });

    var isolateData = IsolateData(imageStream, classifier.interpreter.address);
    List<dynamic> inferenceResults = await inference(isolateData);

    setState(() {
      inferences = inferenceResults;
      predicting = false;
      initialized = true;

      List<int> pointA = [inferenceResults[7][0], inferenceResults[7][1]];
      List<int> pointB = [inferenceResults[5][0], inferenceResults[5][1]];
      List<int> pointC = [inferenceResults[11][0], inferenceResults[11][1]];
      test_angle2 = getAngle(pointA, pointB, pointC);

      pointA = [inferenceResults[5][0], inferenceResults[5][1]];
      pointB = [inferenceResults[11][0], inferenceResults[11][1]];
      pointC = [inferenceResults[13][0], inferenceResults[13][1]];
      test_angle3 = getAngle(pointA, pointB, pointC);

      int limbsIndex = 0;

      if (!rest) {
        if (handler.doneSets < sets) {
          if (handler.doneReps < reps) {
            handler.checkLimbs(inferenceResults, limbsIndex);
            isProperForm = handler.isPostureCorrect();
            handler.doReps(inferenceResults);
            setState(() {
              doneReps = handler.doneReps;
              stage = handler.stage;
              test_angle1 = handler.angle;

              _progress!.value = ((test_angle1 - 90) * 100 / 180);

              if(test_angle1 > 110) {

              }else if(test_angle1 < 85) {

              }

            });
          } else {
            handler.doneReps = 0;
            handler.doneSets++;
            setState(() {
              doneReps = handler.doneReps;
              doneSets = handler.doneSets;
              rest = true;
              restTime = 30;
            });
          }
        } else {
          handler.doneSets = 0;
          handler.doneReps = 0;
          setState(() {
            doneReps = handler.doneReps;
            doneSets = handler.doneSets;
            nextWorkout();
            rest = true;
            restTime = 60;
          });
        }
      } else {
        setState(() {
          restTime = 0;
          rest = false;
        });
      }
    });
  }

  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child:
              initialized ?
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  foregroundPainter:
                  RenderLandmarks(inferences, limbs),
                  child: !cameraController!.value.isInitialized
                      ? Container()
                      : Transform.scale(
                    scale: 1 / (cameraController!.value.aspectRatio * MediaQuery.of(context).size.aspectRatio),
                    child: Center(
                      child: CameraPreview(cameraController!),
                    ),
                    // child: AspectRatio(
                    //   aspectRatio: cameraController!.value.aspectRatio,
                    //   child: CameraPreview(cameraController!),
                    // ),
                  ),
                ),
              )
                  : Container(),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 50),
            //   child: Container(
            //     height: MediaQuery.of(context).size.height,
            //     child: Column(
            //       children: [
            //         Expanded(
            //           child: rive.Rive(
            //             artboard: _riveArtboard!,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  DefaultTextStyle(
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25, color: Colors.black),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Reps: " + doneReps.toString()),
                            SizedBox(
                              width: 5,
                            ),
                            Text(" / " + reps.toString())
                          ],
                        ),
                        Row(
                          children: [
                            Text("Sets: " + doneSets.toString()),
                            SizedBox(
                              width: 5,
                            ),
                            Text(" / " + sets.toString())
                          ],
                        ),
                        Row(
                          children: [
                            Text("Angles: " + test_angle1.toStringAsFixed(0)),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Angles(허리): " + test_angle3.toStringAsFixed(0)),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}

class RenderLandmarks extends CustomPainter {
  late List<dynamic> inferenceList;
  late PointMode pointMode;
  late List<dynamic> selectedLandmarks;

  // COLOR PROFILES

  // CORRECT POSTURE COLOR PROFILE
  // ignore: non_constant_identifier_names
  var point_green = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  // ignore: non_constant_identifier_names
  var edge_green = Paint()
    ..color = Colors.blue
    ..strokeWidth = 5;

  // INCORRECT POSTURE COLOR PROFILE

  // ignore: non_constant_identifier_names
  var point_red = Paint()
    ..color = Colors.red
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  // ignore: non_constant_identifier_names
  var edge_red = Paint()
    ..color = Colors.red
    ..strokeWidth = 5;

  // ignore: non_constant_identifier_names
  List<Offset> points_green = [];
  // ignore: non_constant_identifier_names
  List<Offset> points_red = [];

  List<dynamic> edges = [
    [0, 1], // nose to left_eye
    [0, 2], // nose to right_eye
    [1, 3], // left_eye to left_ear
    [2, 4], // right_eye to right_ear
    [0, 5], // nose to left_shoulder
    [0, 6], // nose to right_shoulder
    [5, 7], // left_shoulder to left_elbow
    [7, 9], // left_elbow to left_wrist
    [6, 8], // right_shoulder to right_elbow
    [8, 10], // right_elbow to right_wrist
    [5, 6], // left_shoulder to right_shoulder
    [5, 11], // left_shoulder to left_hip
    [6, 12], // right_shoulder to right_hip
    [11, 12], // left_hip to right_hip
    [11, 13], // left_hip to left_knee
    [13, 15], // left_knee to left_ankle
    [12, 14], // right_hip to right_knee
    [14, 16] // right_knee to right_ankle
  ];
  RenderLandmarks(List<dynamic> inferences, List<dynamic> included) {
    inferenceList = inferences;
    selectedLandmarks = included;
  }
  @override
  void paint(Canvas canvas, Size size) {
    // for (List<int> edge in edges) {
    //   double vertex1X = inferenceList[edge[0]][0].toDouble() - 70;
    //   double vertex1Y = inferenceList[edge[0]][1].toDouble() - 30;
    //   double vertex2X = inferenceList[edge[1]][0].toDouble() - 70;
    //   double vertex2Y = inferenceList[edge[1]][1].toDouble() - 30;
    //   canvas.drawLine(
    //       Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y), edge_paint);
    // }

    for (var limb in selectedLandmarks) {
      renderEdge(canvas, limb[0], limb[1]);
    }
    canvas.drawPoints(PointMode.points, points_green, point_green);
    canvas.drawPoints(PointMode.points, points_red, point_red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void renderEdge(Canvas canvas, List<int> included, bool isCorrect) {
    for (List<dynamic> point in inferenceList) {
      if ((point[2] > 0.40) & included.contains(inferenceList.indexOf(point))) {
        isCorrect
            ? points_green
            .add(Offset(point[0].toDouble() - 70, point[1].toDouble() - 30))
            : points_red.add(
            Offset(point[0].toDouble() - 70, point[1].toDouble() - 30));
      }
    }

    for (List<int> edge in edges) {
      if (included.contains(edge[0]) & included.contains(edge[1])) {
        double vertex1X = inferenceList[edge[0]][0].toDouble() - 70;
        double vertex1Y = inferenceList[edge[0]][1].toDouble() - 30;
        double vertex2X = inferenceList[edge[1]][0].toDouble() - 70;
        double vertex2Y = inferenceList[edge[1]][1].toDouble() - 30;
        canvas.drawLine(Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y),
            isCorrect ? edge_green : edge_red);
      }
    }
  }
}