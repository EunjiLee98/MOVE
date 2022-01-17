import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/coral/dumbbellRive.dart';
import 'package:move/coral/webSocket.dart';
import 'package:move/exercise/crossJack.dart';
import 'package:move/exercise/jumpingJack.dart';
import 'package:move/exercise/squatRive.dart';
import 'package:move/front/bluetooth.dart';
import 'package:camera/camera.dart';
import 'package:move/front/temp.dart';
import 'package:move/theme/font.dart';
import 'package:rive/rive.dart';

class Training extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;

  Training({this.bluetoothServices, this.cameras});

  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training> with SingleTickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: whiteRusso('Exercise', 25, false),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('background.png'), fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 60),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35, 40, 35, 0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xff5A0CAE).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(
                          170,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              25.0,
                            ),
                            color: Color(0xff5A0CAE),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            Tab(
                              // text: 'sdf',
                              child: whiteNoto('유산소운동', 16, false),
                            ),
                            Tab(
                              child: whiteNoto('무산소운동', 16, false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  if(widget.bluetoothServices != null)
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingjack(bluetoothServices: widget.bluetoothServices)));
                                  if (widget.bluetoothServices == null)
                                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Bluetooth()));
                                    });
                                },
                                child: Image.asset('jumpingButton.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  if(widget.bluetoothServices != null)
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Crossjack(bluetoothServices: widget.bluetoothServices)));
                                  if (widget.bluetoothServices == null)
                                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Bluetooth()));
                                    });
                                },
                                child: Image.asset('crossButton.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  // if(widget.bluetoothServices != null)
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                                },
                                child: Image.asset('buffett.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  // if(widget.bluetoothServices != null)
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(bluetoothServices: widget.bluetoothServices)));
                                },
                                child: Image.asset('hurdle.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(cameras: widget.cameras!, title: 'MOVE! - Squat Rive',)));
                                },
                                child: Image.asset('squatButton.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WebSocket()));
                                },
                                child: Image.asset('dumbbellButton.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  // if(widget.bluetoothServices != null)
                                },
                                child: Image.asset('crunch.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  // if(widget.bluetoothServices != null)
                                },
                                child: Image.asset('plank.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  // if(widget.bluetoothServices != null)
                                },
                                child: Image.asset('pushUp.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                              TextButton(
                                onPressed: () {
                                  // if(widget.bluetoothServices != null)
                                },
                                child: Image.asset('bridge.png', width: MediaQuery.of(context).size.width*0.9,),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
