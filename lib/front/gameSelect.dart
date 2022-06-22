import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/coral/dumbbellRive_2pwin.dart';
import 'package:move/coral/webSocket.dart';
import 'package:move/front/bluetooth.dart';
import 'package:flutter/services.dart';
import 'package:move/game/trex/trex_tutorial.dart';
import 'package:move/theme/font.dart';
import '../game/boxing.dart';
import '../game/fishing.dart';
import 'package:move/coral/dumbbellRive_1pwin.dart';

class GameSelect extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  GameSelect({this.bluetoothServices, this.cameras});

  @override
  _GameSelectState createState() => _GameSelectState();
}

class _GameSelectState extends State<GameSelect> {
  @override
  void initState() {
    super.initState();
 //screen vertically
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: whiteRusso('Game', 25, false),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('background.png'),
                  fit: BoxFit.fill
              )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 60),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30,),
                  TextButton(
                    onPressed: () {
                      if(widget.bluetoothServices != null)
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                TrexTutorial(bluetoothServices: widget
                                    .bluetoothServices!)));
                      if (widget.bluetoothServices == null)
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Bluetooth()));
                        });
                    },
                    child: Image.asset('dinoButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  // SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                      if (widget.bluetoothServices != null)
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                BoxingStart(bluetoothServices: widget
                                    .bluetoothServices, cameras: widget.cameras,)));
                      if (widget.bluetoothServices == null)
                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Bluetooth()));
                        });
                    },
                    child: Image.asset('boxButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  // SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                      SchedulerBinding.instance!.addPostFrameCallback((_) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WebSocket()));
                      });
                    },
                    child: Image.asset('dumbbellRiveButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.8,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => FishingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('fishing.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  TextButton(
                    onPressed: () {
                      // if(widget.bluetoothServices != null)
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => BoxingStart(bluetoothServices: widget.bluetoothServices)));
                    },
                    child: Image.asset('jumprope.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      ),
    );
  }
}