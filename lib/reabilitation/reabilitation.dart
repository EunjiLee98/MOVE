import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/reabilitation/pushed_page.dart';

class ReabSelect extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  ReabSelect({this.bluetoothServices, this.cameras});

  @override
  _ReabSelectState createState() => _ReabSelectState();
}

class _ReabSelectState extends State<ReabSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재활 및 근력'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PushedPage(
                      cameras: widget.cameras!,
                      title: 'posenet',
                      name: 'Warrior',
                    ),
                ));
              },
              child: Text('Warrior')
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PushedPage(
                    cameras: widget.cameras!,
                    title: 'posenet',
                    name: 'Tree',
                  ),
                ));
              },
              child: Text('Tree')
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PushedPage(
                    cameras: widget.cameras!,
                    title: 'posenet',
                    name: 'Bow',
                  ),
                ));
              },
              child: Text('Bow')
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PushedPage(
                    cameras: widget.cameras!,
                    title: 'posenet',
                    name: 'Leg',
                  ),
                ));
              },
              child: Text('Leg')
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PushedPage(
                    cameras: widget.cameras!,
                    title: 'posenet',
                    name: 'Side',
                  ),
                ));
              },
              child: Text('Side')
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PushedPage(
                    cameras: widget.cameras!,
                    title: 'posenet',
                    name: 'rive',
                  ),
                ));
              },
              child: Text('Rive Text')
          ),
        ],
      ),
    );
  }
}


