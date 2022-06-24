import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:move/reabilitation/side.dart';
import 'package:move/reabilitation/test/test2(dumbbell).dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'test/test.dart';
import 'package:move/reabilitation/warrior.dart';
import 'package:move/reabilitation/tree.dart';
import 'package:move/reabilitation/bow.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';
import 'package:move/reabilitation/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'dart:io';

import 'leg.dart';

class PushedPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String name;
  const PushedPage({required this.cameras, required this.title, required this.name});
  @override
  _PushedPageState createState() => _PushedPageState();
}

class _PushedPageState extends State<PushedPage> {
  List<dynamic>? _data;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int x = 1;

  @override
  void initState() {
    super.initState();
    // var res = loadModel();
    // print('Model Response: ' + res.toString());
  }

  _setRecognitions(data, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _data = data;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  // loadModel() async {
  //   return await Interpreter.fromAsset("lite-model_movenet_singlepose_lightning_3.tflite");
  // }

  // loadModel() async {
  //   return await Tflite.loadModel(
  //       model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
  //       // model: "assets/lite-model_movenet_singlepose_lightning_3.tflite");
  //       // model: "assets/lite-model_movenet_multipose_lightning_tflite_float16_1.tflite");
  // }

  // late Interpreter _interpreter;
  // TensorBuffer outputLocations = TensorBufferFloat([]);
  //
  // loadModel({Interpreter? interpreter}) async {
  //   try {
  //     _interpreter = interpreter ??
  //         await Interpreter.fromAsset(
  //           "model.tflite",
  //           options: InterpreterOptions()..threads = 4,
  //         );
  //   } catch (e) {
  //     print("Error while creating interpreter: $e");
  //   }
  //
  //   outputLocations = TensorBufferFloat([1, 1, 17, 3]);
  // }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    String name = widget.name;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Camera(
          //   cameras: widget.cameras,
          //   setRecognitions: _setRecognitions,
          // ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white,)),
                Text('$name Pose', style: TextStyle(color: Colors.white, fontSize: 20),),
              ],
            ),
          ),
          if(widget.name == 'Warrior') ...[
            Test()
            // Warrior(
            //   data: _data == null ? [] : _data,
            //   previewH: max(_imageHeight, _imageWidth),
            //   previewW: min(_imageHeight, _imageWidth),
            //   screenH: screen.height,
            //   screenW: screen.width,
            // ),
          ]else if(widget.name == 'Tree') ...[
            Test2()
            // Tree(
            //   data: _data == null ? [] : _data,
            //   previewH: max(_imageHeight, _imageWidth),
            //   previewW: min(_imageHeight, _imageWidth),
            //   screenH: screen.height,
            //   screenW: screen.width,
            // ),
          ]else if(widget.name == 'Bow') ...[
            Bow(
              data: _data == null ? [] : _data,
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
            ),
          ]else if(widget.name == 'Leg') ...[
            Leg(
              data: _data == null ? [] : _data,
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
            ),
          ]else if(widget.name == 'Side') ...[
            Side(
              data: _data == null ? [] : _data,
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
            ),
          ]
        ],
      ),
    );
  }
}
