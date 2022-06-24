// import 'dart:ffi';
// import 'utility.dart';
//
// class ExerciseHandler {
//   late List<dynamic> limbs;
//   late List<dynamic> targets;
//
//   late bool isProperForm;
//   late bool restart;
//   late int doneReps;
//   late int doneSets;
//
//   late var stage;
//   late double angle;
//
//   bool isPostureCorrect() {
//     for (var limb in limbs) {
//       if (limb[1] == false) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   void checkLimbs(var inferenceResults, var limbsIndex) {
//     for (var limb in limbs) {
//       var A = limb[0][0];
//       var B = limb[0][1];
//       var C = limb[0][2];
//
//       List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
//       List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
//       List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
//
//       var angle = getAngle(pointA, pointB, pointC);
//
//       if (angle >= limb[2] && angle <= limb[3]) {
//         limbs[limbsIndex][1] = true;
//       } else {
//         limbs[limbsIndex][1] = false;
//       }
//       limbsIndex += 1;
//     }
//   }
// }
//
// // Dumbell Curl Handler
//
// class DumbellCurlHandler extends ExerciseHandler {
//   void init() {
//     limbs = [
//       [
//         [7, 5, 11],
//         false,
//         5,
//         25
//       ],
//       [
//         [5, 11, 13],
//         false,
//         170,
//         180
//       ],
//     ];
//     targets = [
//       [
//         [5, 7, 9],
//         false
//       ],
//     ];
//
//     doneReps = 0;
//     doneSets = 0;
//     angle = 0;
//     stage = "start";
//     restart = true;
//   }
//
//   void doReps(var inferenceResults) {
//     if (isPostureCorrect()) {
//       for (var target in targets) {
//         var A = target[0][0];
//         var B = target[0][1];
//         var C = target[0][2];
//         List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
//         List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
//         List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
//         angle = getAngle(pointA, pointB, pointC);
//
//         print("TARGET ANGLE: " + angle.toString());
//       }
//       if (restart) {
//         if (angle > 150) {
//           stage = "up";
//           restart = false;
//         }
//       } else {
//         if (angle < 35) {
//           stage = "down";
//         }
//         if (angle > 150 && stage == "down") {
//           stage = "up";
//           doneReps += 1;
//         }
//       }
//     } else {
//       restart = true;
//       stage = "start";
//       // print("restart");
//     }
//   }
// }

import 'dart:ffi';
import 'utility.dart';

class ExerciseHandler {
  late List<dynamic> limbs;
  late List<dynamic> targets;

  late bool isProperForm;
  late bool restart;
  late int doneReps;
  late int doneSets;

  late var stage;
  late double angle;
  late double angle2;

  bool isPostureCorrect() {
    for (var limb in limbs) {
      if (limb[1] == false) {
        return false;
      }
    }
    return true;
  }

  void checkLimbs(var inferenceResults, var limbsIndex) {
    for (var limb in limbs) {
      var A = limb[0][0];
      var B = limb[0][1];
      var C = limb[0][2];

      List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
      List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
      List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];

      var angle = getAngle(pointA, pointB, pointC);

      if (angle >= limb[2] && angle <= limb[3]) {
        limbs[limbsIndex][1] = true;
      } else {
        limbs[limbsIndex][1] = false;
      }
      limbsIndex += 1;
    }
  }
}

// Dumbell Curl Handler

class DumbellCurlHandler extends ExerciseHandler {
  var angle = 0;
  var angle2 = 0;

  List<int> pointA = [];
  List<int> pointB = [];
  List<int> pointC = [];

  void init() {
    limbs = [
      [
        [7, 5, 11],
        false,
        0,
        180
      ],
      [
        [5, 11, 13],
        false,
        0,
        180
      ],
      // [
      //   [5, 11, 13],
      //   false,
      //   80,
      //   110
      // ],
    ];
    targets = [
      [
        [11, 13, 15],
        false
      ],
      [
        [5, 11, 13],
        false,
        // 80,
        // 110
      ],
    ];

    doneReps = 0;
    doneSets = 0;
    stage = "start";
    restart = true;
  }

  void doReps(var inferenceResults) {
    if (isPostureCorrect()) {
      var a = 11;
      var b = 13;
      var c = 15;

      pointA = [inferenceResults[a][0], inferenceResults[a][1]];
      pointB = [inferenceResults[b][0], inferenceResults[b][1]];
      pointC = [inferenceResults[c][0], inferenceResults[c][1]];
      angle = getAngle(pointA, pointB, pointC);

      a = 5;
      b = 11;
      c = 13;

      pointA = [inferenceResults[a][0], inferenceResults[a][1]];
      pointB = [inferenceResults[b][0], inferenceResults[b][1]];
      pointC = [inferenceResults[c][0], inferenceResults[c][1]];
      angle2 = getAngle(pointA, pointB, pointC);

      if (restart) {
        if (angle > 150) {
          stage = "up";
          restart = false;
        }
      } else {
        if (angle < 130 && angle2 > 80 && angle2 < 110) {
          stage = "down";
        }
        if (angle > 150 && stage == "down" && angle2 > 80 && angle2 < 110) {
          stage = "up";
          doneReps += 1;
        }
      }
    } else {
      restart = true;
      stage = "start";
      // print("restart");
    }
  }
}
