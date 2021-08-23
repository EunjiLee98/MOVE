import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:move/reabilitation/yoga.dart';
import 'package:move/reabilitation/yoga2.dart';
import 'package:move/reabilitation/yoga3.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';
import 'package:move/reabilitation/camera.dart';

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
    var res = loadModel();
    print('Model Response: ' + res.toString());
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

  loadModel() async {
    return await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    String name = widget.name;
    return Scaffold(
      appBar: AppBar(
        title: Text('$name Pose'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          if(widget.name == 'Warrior') ...[
            Yoga(
              data: _data == null ? [] : _data,
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
            ),
          ]else if(widget.name == 'Tree') ...[
            Yoga2(
              data: _data == null ? [] : _data,
              previewH: max(_imageHeight, _imageWidth),
              previewW: min(_imageHeight, _imageWidth),
              screenH: screen.height,
              screenW: screen.width,
            ),
          ]else if(widget.name == 'Bow') ...[
            Yoga3(
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
