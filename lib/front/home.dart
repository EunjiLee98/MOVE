import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/select.dart';
import 'package:move/theme/font.dart';
import 'package:flutter/services.dart';
import 'gameSelect.dart';
import 'training.dart';

import 'bluetooth.dart';

class Temp extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  final int index;
  const Temp({this.bluetoothServices, this.cameras, required this.index});

  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  int _currentIndex = 0;
  static List<BluetoothService> bluetoothServices = [];
  static List<CameraDescription> cameras = [];

  @override
  void initState() {
    _currentIndex = widget.index;
    super.initState();
  }

  List<Widget> _children() => [
    Homepage(),
    Training(),
    GameSelect(),
    GameSelect()
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: widget.index,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) => {
            setState(() {
              _currentIndex = index;
            })
          },
          items: [
            BottomNavigationBarItem(
                title: Column(
                  children: [
                    SizedBox(height: 5,),
                    whiteNoto('홈', 14, false),
                  ],
                ),
                icon: _currentIndex == 0
                    ? Column(
                      children: [
                        SizedBox(height: 2,),
                        Image.asset('home_fill.png', width: 30,),
                      ],
                    )
                    : Column(
                      children: [
                        SizedBox(height: 2,),
                        Image.asset('home_line.png', width: 30,),
                      ],
                    )
            ),
            BottomNavigationBarItem(
                title: Column(
                  children: [
                    SizedBox(height: 4,),
                    whiteNoto('운동', 14, false),
                  ],
                ),
                icon: _currentIndex == 1
                    ? Column(
                      children: [
                        SizedBox(height: 3,),
                        Image.asset('training_fill.png', width: 30,),
                      ],
                    )
                    : Column(
                      children: [
                        SizedBox(height: 2,),
                        Image.asset('training_line.png', width: 30,),
                      ],
                    )
            ),
            BottomNavigationBarItem(
                title: Column(
                  children: [
                    SizedBox(height: 4,),
                    whiteNoto('게임', 14, false),
                  ],
                ),
                icon: _currentIndex == 2
                    ? Column(
                      children: [
                        SizedBox(height: 6,),
                        Image.asset('game_fill.png', width: 40,),
                      ],
                    )
                    : Column(
                      children: [
                        SizedBox(height: 6,),
                        Image.asset('game_line.png', width: 40,),
                      ],
                    )
            ),
            BottomNavigationBarItem(
                title: Column(
                  children: [
                    SizedBox(height: 1,),
                    whiteNoto('설정', 14, false),
                  ],
                ),
                icon: _currentIndex == 3
                    ? Column(
                      children: [
                        Image.asset('setting_fill.png', width: 37,),
                      ],
                    )
                    : Column(
                      children: [
                        Image.asset('setting_line.png', width: 37,),
                      ],
                    )
            ),
          ],
        ),
      ),
      body: children[_currentIndex],
    );
  }
}


class Homepage extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  Homepage({this.bluetoothServices, this.cameras});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Homepage> {
  List rankId = [];
  List<String> total = [];
  List<String> name = [];
  List<String> photo = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); //screen vertically

    FirebaseFirestore.instance
        .collection('user')
        .where('avg', isGreaterThan: 0)
        .orderBy('avg', descending: true)
        .limit(5)
        .snapshots()
        .listen((data) {
      setState(() {
        data.docs.forEach((element) {
          if(!rankId.contains(element.get('id'))) {
            rankId.add(element.get('id'));
            total.add(element.get('avg').toString());
            name.add(element.get('name').toString());
            photo.add(element.get('photo').toString());
          }
        });
      });
    });
  }

  @override
  void dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: <Widget> [
          Container(
            width: 60,
            child: TextButton(
              onPressed: () {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Bluetooth(cameras: widget.cameras)));
                });
              },
              child: Image.asset('bluetooth.png', width: MediaQuery.of(context).size.width*0.08,),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    child: Image.asset('point.png'),
                  ),
                ),
                Positioned(
                  left: 42,
                  top: 20,
                  child: whiteRusso('12,000', 15, true),
                )
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('background.png'),
                    fit: BoxFit.fill
                )
            ),
            child: Container(
              margin: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.baseline, //line alignment
                textBaseline: TextBaseline.alphabetic, //line alignment
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 15),
                        Column(
                          children: [
                            Row(
                              children: [
                                navyNoto(FirebaseAuth.instance.currentUser!.displayName.toString(), 23, true),
                                whiteNoto('님', 23, true),
                              ],
                            ),
                            SizedBox(height: 5),
                            whiteNoto('오늘도 무브하세요!', 23, true),
                          ],
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 20,),
                  Flexible(
                    child: FutureBuilder(
                      builder: (context, snapshot) {
                        return MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: rankId.length,
                              itemBuilder: (context, index) {
                                var num = index + 1;
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(1, 1, 1, 5),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.8,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(20),
                                        // gradient: LinearGradient(
                                        //   begin: Alignment.topCenter,
                                        //   end: Alignment.bottomCenter,
                                        //   colors: [const Color(0xffFFEED9), const Color(0xffF1E4A0)],
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.indigo.withOpacity(0.15),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          )
                                        ]
                                    ),
                                    child: ListTile(
                                      title: Text(name[index], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),),
                                      subtitle: Text(total[index], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),),
                                      leading: Container(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            Image.asset('$num.png', width: 50),
                                            SizedBox(width: 10,),
                                            Container(
                                              width: 50,
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(photo[index]),
                                                backgroundColor: Colors.transparent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(height: 10,),
                  // Center(
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width*0.8,
                  //     child: TextButton(
                  //         onPressed: () {
                  //           Navigator.push(context,
                  //               MaterialPageRoute(builder: (context) => Select(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras)));
                  //         },
                  //         child: Image.asset('moveButton.png')
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}