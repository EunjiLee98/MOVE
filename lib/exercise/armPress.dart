import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';
import 'package:move/reabilitation/camera.dart';
import 'package:move/exercise/armPress_data.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white,)),
                Text('Arm Press', style: TextStyle(color: Colors.white, fontSize: 20),),
              ],
            ),
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
