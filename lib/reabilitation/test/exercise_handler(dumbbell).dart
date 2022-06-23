import 'dart:ffi';
import 'utility.dart';

class ExerciseHandler2 {
  late List<dynamic> limbs2;
  late List<dynamic> targets2;

  late bool isProperForm2;
  late bool restart2;
  late int doneReps2;
  late int doneSets2;

  late var stage2;
  late double angle2;

  bool isPostureCorrect2() {
    for (var limb in limbs2) {
      if (limb[1] == false) {
        return false;
      }
    }
    return true;
  }

  void checkLimbs2(var inferenceResults, var limbsIndex) {
    for (var limb in limbs2) {
      var A = limb[0][0];
      var B = limb[0][1];
      var C = limb[0][2];

      List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
      List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
      List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];

      var angle = getAngle(pointA, pointB, pointC);

      if (angle >= limb[2] && angle <= limb[3]) {
        limbs2[limbsIndex][1] = true;
      } else {
        limbs2[limbsIndex][1] = false;
      }
      limbsIndex += 1;
    }
  }
}

// Dumbell Curl Handler

class DumbellCurlHandler2 extends ExerciseHandler2 {
  void init() {
    limbs2 = [
      [
        [7, 5, 11],
        false,
        5,
        25
      ],
      [
        [5, 11, 13],
        false,
        170,
        180
      ],
    ];
    targets2 = [
      [
        [5, 7, 9],
        false
      ],
    ];

    doneReps2 = 0;
    doneSets2 = 0;
    angle2 = 0;
    stage2 = "start";
    restart2 = true;
  }

  void doReps2(var inferenceResults) {
    if (isPostureCorrect2()) {
      for (var target in targets2) {
        var A = target[0][0];
        var B = target[0][1];
        var C = target[0][2];
        List<int> pointA = [inferenceResults[A][0], inferenceResults[A][1]];
        List<int> pointB = [inferenceResults[B][0], inferenceResults[B][1]];
        List<int> pointC = [inferenceResults[C][0], inferenceResults[C][1]];
        angle2 = getAngle(pointA, pointB, pointC);

        print("TARGET ANGLE: " + angle2.toString());
      }
      if (restart2) {
        if (angle2 > 150) {
          stage2 = "up";
          restart2 = false;
        }
      } else {
        if (angle2 < 35) {
          stage2 = "down";
        }
        if (angle2 > 150 && stage2 == "down") {
          stage2 = "up";
          doneReps2 += 1;
        }
      }
    } else {
      restart2 = true;
      stage2 = "start";
      // print("restart");
    }
  }
}