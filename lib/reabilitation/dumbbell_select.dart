import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:move/reabilitation/pushed_page.dart';
import 'package:move/theme/font.dart';

import '../main.dart';

class DumbbellSelect extends StatefulWidget {
  final List<CameraDescription>? cameras;

  DumbbellSelect({this.cameras});

  @override
  _DumbbellSelectState createState() => _DumbbellSelectState();
}

class _DumbbellSelectState extends State<DumbbellSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {Navigator.pop(context);},
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('tutorial1_background.png'),
                fit: BoxFit.fill
            )
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('dumbbell_back.png'),
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                      fit: BoxFit.fill
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Center(
                    child: Column(
                      children: [
                        whiteRusso('Dumbbell Curl', 32, true),
                        SizedBox(height: 5,),
                        whiteNoto('덤벨 컬', 23, false),
                        SizedBox(height: 10,),
                        whiteNoto('덤벨운동은 상체 근력 증진, 심혈관 건강 개선,', 13, false),
                        whiteNoto('이두근 및 삼두근 등의 팔 근육 강화, 지구력 증진,', 13, false),
                        whiteNoto('어깨 및 가슴 근육 강화를 도와줍니다.', 13, false),
                      ],
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Color(0xff9677EC),
                      minWidth: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height*0.15,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DumbbellTutorial(cameras: widget.cameras)));
                      },
                      child: Column(
                        children: [
                          whiteNoto('초급세트', 22, false),
                          SizedBox(height: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width*0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time, color: Colors.white, size: 12,),
                                whiteNoto('5분', 12, false),
                                whiteNoto('   |   ', 12, false),
                                whiteNoto('3세트', 12, false),
                                whiteNoto('   |   ', 12, false),
                                whiteNoto('난이도 ■□□', 12, false),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Color(0xff7B52EF),
                    minWidth: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.15,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DumbbellTutorial(cameras: widget.cameras)));
                    },
                    child: Column(
                      children: [
                        whiteNoto('중급세트', 22, false),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time, color: Colors.white, size: 12,),
                              whiteNoto('10분', 12, false),
                              whiteNoto('   |   ', 12, false),
                              whiteNoto('5세트', 12, false),
                              whiteNoto('   |   ', 12, false),
                              whiteNoto('난이도 ■■□', 12, false),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Color(0xff6838EC),
                    minWidth: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.15,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DumbbellTutorial(cameras: widget.cameras)));
                    },
                    child: Column(
                      children: [
                        whiteNoto('고급세트', 22, false),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time, color: Colors.white, size: 12,),
                              whiteNoto('20분', 12, false),
                              whiteNoto('   |   ', 12, false),
                              whiteNoto('10세트', 12, false),
                              whiteNoto('   |   ', 12, false),
                              whiteNoto('난이도 ■■■', 12, false),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DumbbellTutorial extends StatefulWidget {
  final List<CameraDescription>? cameras;

  DumbbellTutorial({this.cameras});

  @override
  _DumbbellTutorialState createState() => _DumbbellTutorialState();
}

class _DumbbellTutorialState extends State<DumbbellTutorial> {
  int tutoIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> tutorial = [
      Container(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.8,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('camera.png',),
              width: MediaQuery.of(context).size.width*0.2,),
            SizedBox(height: 30,),
            blackNoto('카메라 접근권한을 허용해주세요.', 18, true),
            SizedBox(height: 10,),
            blackNoto('사용자님의 운동자세 정확도를 체크하여', 14, false),
            blackNoto('피드백을 제공하기 위함입니다.', 14, false),
            SizedBox(height: 30,),
            blackNoto('1/2', 14, false),
            SizedBox(height: 10,),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Color(0xff7B52EF),
              onPressed: () {
                setState(() {
                  tutoIndex++;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: whiteRusso('OK', 23, false),
              ),
            ),
          ],
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.8,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('phone.png',),
              width: MediaQuery.of(context).size.width*0.2,),
            SizedBox(height: 30,),
            blackNoto('휴대폰을 안정적으로 거치해주세요.', 18, true),
            SizedBox(height: 10,),
            blackNoto('전신이 카메라에 담기도록 휴대폰을', 14, false),
            blackNoto('평평한 곳이나 거치대로 고정시켜주세요.', 14, false),
            SizedBox(height: 30,),
            blackNoto('2/2', 14, false),
            SizedBox(height: 10,),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Color(0xff7B52EF),
              onPressed: () {
                setState(() {
                  tutoIndex++;
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: whiteRusso('OK', 23, false),
              ),
            ),
          ],
        ),
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.looks_one_rounded, color: Colors.white70, size: 28,),
            SizedBox(height: 10,),
            whiteNoto('덤벨을 잡은 상태로 어깨를 내리고', 16, true),
            whiteNoto('팔꿈치를 몸통에 밀착하여 붙여주세요.', 16, true),
            SizedBox(height: 30,),
            Container(
                height: MediaQuery.of(context).size.height*0.5,
                child: Image.asset('dumbbell_movenet.png')
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PushedPage(
                          cameras: widget.cameras!,
                          title: 'posenet',
                          name: 'Tree',
                        ),
                      ));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: whiteRusso('SKIP', 23, false),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      tutoIndex++;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: navyRusso('Next ▶', 22, false),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.looks_two_rounded, color: Colors.white70, size: 28,),
            SizedBox(height: 10,),
            whiteNoto('팔꿈치의 움직임을 최소화하여', 16, true),
            whiteNoto('덤벨을 어깨 위치까지 들어올립니다.', 16, true),
            SizedBox(height: 30,),
            Container(
                height: MediaQuery.of(context).size.height*0.5,
                child: Image.asset('dumbbell_movenet2.png', fit: BoxFit.fitHeight,)
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                    SchedulerBinding.instance!.addPostFrameCallback((_) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PushedPage(
                          cameras: widget.cameras!,
                          title: 'posenet',
                          name: 'Tree',
                        ),
                      ));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: whiteRusso('SKIP', 23, false),
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      tutoIndex++;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: navyRusso('Next ▶', 22, false),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.looks_3_rounded, color: Colors.white70, size: 28,),
            SizedBox(height: 10,),
            whiteNoto('들어올린 덤벨을 다시', 16, true),
            whiteNoto('처음 위치로 천천히 내려줍니다.', 16, true),
            SizedBox(height: 30,),
            Container(
                height: MediaQuery.of(context).size.height*0.5,
                child: Image.asset('dumbbell_movenet.png')
            ),
            SizedBox(height: 40,),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Color(0xff7B52EF),
              onPressed: () {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PushedPage(
                      cameras: widget.cameras!,
                      title: 'posenet',
                      name: 'Tree',
                    ),
                  ));
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                child: whiteRusso('start', 23, false),
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {Navigator.pop(context);},
        ),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: whiteRusso('Dumbbell Curl', 25, true),
          ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('tutorial1_background.png'),
                fit: BoxFit.fill
            )
        ),
        child: Center(
          child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              items: tutorial.map((item) =>
                  Container(
                    child: Center(
                      child: tutorial[tutoIndex],
                    ),
                  )).toList()
          ),
        ),
      ),
    );
  }
}
