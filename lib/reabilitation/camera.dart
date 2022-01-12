import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  Camera({required this.cameras, required this.setRecognitions});

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController? controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.max,
      );
      controller!.initialize().then((_) {
        var prevFrame = 0;

        if (!mounted) {
          return;
        }

        controller!.startImageStream((img) {
          final now = DateTime.now().millisecondsSinceEpoch;

          if (!isDetecting) {
            isDetecting = true;

            Tflite.runPoseNetOnFrame(
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              imageHeight: img.height,
              imageWidth: img.width,
              //numResults: 2,
              numResults: 1,
              rotation: -90,
              threshold: 0.1,
              // nmsRadius: 10,
            ).then((recognitions) {
              widget.setRecognitions(recognitions!, img.height, img.width);
              isDetecting = false;

              print('>>> Got frame after ${now - prevFrame}ms');
              prevFrame = now;
            });
          }
        });

        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller!.value.previewSize!;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return CameraPreview(controller!);
    // return OverflowBox(
    //   // maxHeight: MediaQuery.of(context).size.height*0.4,
    //   //     // screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
    //   // maxWidth: MediaQuery.of(context).size.width*0.4,
    //       // screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
    //   child: CameraPreview(controller!),
    // );
  }
}
