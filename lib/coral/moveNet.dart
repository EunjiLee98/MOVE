import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move/coral/moveNet_page.dart';
import 'package:move/exercise/squat_page.dart';
import 'package:tflite/tflite.dart';
import 'dart:math';
import 'package:move/reabilitation/camera.dart';

class MoveNet extends StatefulWidget {
  @override
  _MoveNetState createState() => _MoveNetState();
}

class _MoveNetState extends State<MoveNet> {
  List<dynamic> ? _data;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int x = 1;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white,)),
                Text('Coral & MoveNet', style: TextStyle(color: Colors.white, fontSize: 20),),
              ],
            ),
          ),
          MoveNetPage(
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
