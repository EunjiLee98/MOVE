
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/exercise/armPress.dart';
import 'package:move/exercise/crossJack.dart';
import 'package:move/exercise/jumpingJack.dart';
import 'package:move/exercise/squatRive.dart';
import 'package:move/front/bluetooth.dart';
import 'package:camera/camera.dart';
import 'package:rive/rive.dart';

class Training extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  Training({this.bluetoothServices, this.cameras});

  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Home Workout', style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('background.png'),
                    fit: BoxFit.fill
                )
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30,),
                    TextButton(
                      onPressed: () {
                        if(widget.bluetoothServices != null)
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Jumpingjack(bluetoothServices: widget.bluetoothServices)));
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
                    // SizedBox(height: 5,),
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
                    // SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Squat(cameras: widget.cameras!, title: 'MOVE! - Squat Rive',)));
                      },
                      child: Image.asset('squatButton.png', width: MediaQuery.of(context).size.width*0.9,),
                    ),
                    // SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            ArmPress(cameras: widget.cameras!, title: 'MOVE! - Arm Press',)));
                      },
                      child: Image.asset('dumbbell.png', width: MediaQuery.of(context).size.width*0.9,),
                    ),
                    // SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        if(widget.bluetoothServices != null)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RiveTest(bluetoothServices: widget.bluetoothServices)));
                      },
                      child: Image.asset('crunch.png', width: MediaQuery.of(context).size.width*0.9,),
                    ),
                    // SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                      },
                      child: Image.asset('plank.png', width: MediaQuery.of(context).size.width*0.9,),
                    ),
                    // SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                      },
                      child: Image.asset('pushUp.png', width: MediaQuery.of(context).size.width*0.9,),
                    ),
                    // SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        // if(widget.bluetoothServices != null)
                      },
                      child: Image.asset('bridge.png', width: MediaQuery.of(context).size.width*0.9,),
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
            ),
          );
        }
        )
    );
  }
}

class RiveTest extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  RiveTest({this.bluetoothServices});

  @override
  _RiveTestState createState() => _RiveTestState();
}

class _RiveTestState extends State<RiveTest> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;

  late RiveAnimationController _controller;
  late RiveAnimationController _openController;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('Idle');

    _openController = OneShotAnimation(
      'Jumpingjack',
      autoplay: false,
    );

  }

  ListView _buildConnectDeviceView() {
    // ignore: deprecated_member_use
    List<Container> containers = [];
    for (BluetoothService service in widget.bluetoothServices!) {
      // ignore: deprecated_member_use
      List<Widget> characteristicsWidget = [];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read && characteristic.properties.notify) {
          setnum(characteristic);
        }
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Center(child:Text("블루투스 연결설정")),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: RiveAnimation.asset(
            'assets/rive/move_jumpingjack.riv',
            controllers: [_controller, _openController],
          ),
        ),
      ],
    );
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
      setState(() {
        readValues[characteristic.uuid] = value;
        gesture = value.toString();
        gesture_num = int.parse(gesture[1]);
      });
    });

    if(gesture_num == 1) {
      setState(() {
        _openController.isActive = true;
      });
    }

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: const Color(0xff37384E)
          ),
          child: _buildConnectDeviceView()
      )
    );
  }
}