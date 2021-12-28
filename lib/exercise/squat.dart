import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/exercise/squat_page.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';
import 'package:move/reabilitation/camera.dart';

class Squat extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  const Squat({required this.cameras, required this.title, required this.model});

  @override
  _SquatState createState() => _SquatState();
}

class _SquatState extends State<Squat> {
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
        // model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        model: "assets/lite-model_movenet_multipose_lightning_tflite_float16_1.tflite");
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('MOVE! - Squat',style: GoogleFonts.russoOne(
          fontSize: 25,
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          SquatPage(
            data: _data == null ? [] : _data,
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
            //customModel: widget.customModel,
          ),
        ],
      ),
    );
  }
}
