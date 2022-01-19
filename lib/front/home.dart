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
import 'package:rive/rive.dart';
import 'gameSelect.dart';
import 'training.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  @override
  void initState() {
    _currentIndex = widget.index;
    super.initState();
  }

  List<Widget> _children() => [
    Homepage(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras),
    Training(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras),
    GameSelect(bluetoothServices: widget.bluetoothServices),
    GameSelect(bluetoothServices: widget.bluetoothServices)
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
          primaryColor: Colors.transparent
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

  final controller = PageController(viewportFraction: 0.8);
  bool showRanking = false;
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    showRanking = false;

    FirebaseFirestore.instance
        .collection('user')
        .where('avg', isGreaterThan: 0)
        .orderBy('avg', descending: true)
        .limit(10)
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

    _controller = OneShotAnimation(
      'Animation 1',
      autoplay: true,
    );
  }

  // @override
  // void dispose(){
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('background.png'),
                      fit: BoxFit.fill
                  )
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.baseline, //line alignment
                    textBaseline: TextBaseline.alphabetic, //line alignment
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                  top:5,
                                  child: whiteRusso('12,000', 15, true),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 27,
                              backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL.toString()),
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      navyNoto(FirebaseAuth.instance.currentUser!.displayName.toString(), 23, true),
                                      SizedBox(width: 10),
                                      whiteNoto('님', 23, true),
                                    ],
                                  ),
                                  // SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      whiteNoto('오늘도 무브하세요!', 23, true),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 00, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Color(0xffFF7BEA),),
                                    whiteNoto('새내기 무버', 14, true),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Container(
                                    width: MediaQuery.of(context).size.width*0.5,
                                    height: MediaQuery.of(context).size.height*0.5,
                                    child: RiveAnimation.asset('assets/rive/home.riv', fit: BoxFit.fitHeight,)
                                ),
                              ],
                            ),
                            SizedBox(width: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset('1.png', width: 40,),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  decoration: BoxDecoration(
                                    color: Color(0xff290055),
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          whiteNoto('내 무브점수 ⓘ', 14, true),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                whiteRusso('500,000', 25, false),
                                SizedBox(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  decoration: BoxDecoration(
                                      color: Color(0xff290055),
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          whiteNoto('오늘 소모칼로리', 14, true),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.28,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      whiteRusso('150.2', 25, false),
                                      Column(
                                        children: [
                                          whiteRusso('Kcal', 13, false),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  decoration: BoxDecoration(
                                      color: Color(0xff290055),
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          whiteNoto('오늘 운동시간', 14, true),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.28,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      whiteRusso('480', 25, false),
                                      Column(
                                        children: [
                                          whiteRusso('min', 13, false),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Center(child: whiteNoto('7일동안 내 무브', 12, true)),
                      Center(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height*0.26,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: PageView(
                                    controller: controller,
                                    children: [
                                      Container(
                                        child: Image.asset('myMove.png', fit: BoxFit.fitHeight,),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showRanking = !showRanking;
                                          });
                                          Navigator.of(context).push(PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (BuildContext context, _, __) {
                                                return Ranking(
                                                  bluetoothServices: widget.bluetoothServices,
                                                  cameras: widget.cameras,
                                                  rankId: rankId,
                                                  photo: photo,
                                                  name: name,
                                                  total: total,
                                                );
                                              },
                                            transitionDuration: Duration(milliseconds: 500),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              var begin = Offset(0.0, 1.0);
                                              var end = Offset.zero;
                                              var curve = Curves.ease;
                                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                              return SlideTransition(
                                                position: animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          )).then((value) => setState(() {
                                            showRanking = !showRanking;
                                          }));
                                        },
                                        child: showRanking
                                            ? Container()
                                            : Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 16, 0, 20),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height,
                                            decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.8),
                                                borderRadius: BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff5A0CAE).withOpacity(0.15),
                                                    spreadRadius: 5,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 3),
                                                  )
                                                ]
                                            ),
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: Icon(Icons.keyboard_arrow_up, color: Color(0xff5A0CAE), size: 40,),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Color(0xffB59AFF),
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.indigo.withOpacity(0.15),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: Offset(0, 3),
                                                          )
                                                        ]),
                                                    child: ListTile(
                                                      title: name.isEmpty ? whiteNoto('', 15, true) : whiteNoto(name[0], 15, true),
                                                      subtitle: Padding(
                                                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                        child: total.isEmpty ? whiteRusso('', 15, true) : whiteRusso(total[0], 20, true),
                                                      ),
                                                      leading: Container(
                                                        width: 120,
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Image.asset('1.png', width: 50),
                                                              ],
                                                            ),
                                                            SizedBox(width: 10,),
                                                            Container(
                                                              width: 50,
                                                              child: CircleAvatar(
                                                                radius: 30,
                                                                backgroundImage: NetworkImage(photo.isEmpty ? '' : photo[0]),
                                                                backgroundColor: Colors.transparent,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ),
                                    ]
                                ),
                              ),
                              Container(
                                child: SmoothPageIndicator(
                                  controller: controller,
                                  count: 2,
                                  effect: ScaleEffect(
                                    dotWidth: 6,
                                    dotHeight: 6,
                                    dotColor: Colors.white.withOpacity(0.5),
                                    activeDotColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Ranking extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  final List? rankId;
  final List<String>? total;
  final List<String>? name;
  final List<String>? photo;

  const Ranking({this.bluetoothServices, this.cameras,
    required this.rankId,
    required this.total,
    required this.photo,
    required this.name});

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  List rankId = [];
  List<String> total = [];
  List<String> name = [];
  List<String> photo = [];

  @override
  void initState() {
    rankId = widget.rankId!;
    total = widget.total!;
    name = widget.name!;
    photo = widget.photo!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 43,
                bottom: 113,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.78,
                  height: MediaQuery.of(context).size.height*0.7,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Center(
                        child: Icon(Icons.keyboard_arrow_down, color: Color(0xff5A0CAE), size: 40,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xffB59AFF),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.indigo.withOpacity(0.15),
                                                  spreadRadius: 3,
                                                  blurRadius: 7,
                                                  offset: Offset(0, 3),
                                                )
                                              ]),
                                          child: ListTile(
                                            title: Transform(
                                                transform: Matrix4.translationValues(-25, 0.0, 0.0),
                                                child: whiteNoto(name[index], 15, true)),
                                            subtitle: Transform(
                                              transform: Matrix4.translationValues(-25, 0.0, 0.0),
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                child: whiteRusso(total[index], 20, true),
                                              ),
                                            ),
                                            leading: Transform(
                                              transform: Matrix4.translationValues(-5, 0.0, 0.0),
                                              child: Container(
                                                width: 120,
                                                child: Row(
                                                  children: [
                                                    Image.asset('$num.png', width: 40),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      child: CircleAvatar(
                                                        radius: 25,
                                                        backgroundImage: NetworkImage(photo[index]),
                                                        backgroundColor: Colors.transparent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
