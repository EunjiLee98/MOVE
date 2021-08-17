import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';
import 'package:move/reabilitation/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:move/front/armPress_data.dart';

class ArmPress extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  const ArmPress({required this.cameras, required this.title});
  @override
  _ArmPressState createState() => _ArmPressState();
}

class _ArmPressState extends State<ArmPress> {
  List<dynamic> ? _data;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int x = 1;
  FlutterTts ? flutterTts;

  @override
  void initState() {
    super.initState();
    var res = loadModel();
    print('Model Response: ' + res.toString());
    flutterTts = new FlutterTts();
    flutterTts!.speak("팔 운동이 시작되었습니다");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('MOVE! - Arm Press'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          ArmPressData(
            data: _data == null ? [] : _data,
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
          ),
        ],
      ),
    );
  }
}
