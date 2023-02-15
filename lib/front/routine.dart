import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:move/theme/font.dart';

class Routine extends StatefulWidget {
  final String? name;

  Routine({this.name});

  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
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
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('tutorial1_background.png'),
                  fit: BoxFit.fill
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('diet_back.png'),
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 140, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            whiteNoto('고강도 다이어터 루틴', 24, true),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                whiteNoto('#하드코어', 20, false),
                                SizedBox(width: 5,),
                                whiteNoto('#2주완성', 20, false),
                              ],
                            ),
                            SizedBox(height: 10,),
                            whiteNoto('단기간에 체중감량이 필요하신가요?', 13, false),
                            whiteNoto('2주완성 고강도 다이어터 루틴을 시작해보세요!', 13, false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.12,
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('routine.png'),
                                fit: BoxFit.fill
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Color(0xff7B52EF),
                          minWidth: MediaQuery.of(context).size.width*0.8,
                          height: MediaQuery.of(context).size.height*0.12,
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => SquatTutorial(cameras: widget.cameras, level: '초급',)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              whiteRusso('Jumping Jack', 18, false),
                              SizedBox(height: 10,),
                              Container(
                                width: MediaQuery.of(context).size.width*0.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    whiteNoto('점핑잭', 14, false),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, color: Colors.white, size: 12,),
                                        whiteNoto('2분', 14, false),
                                      ],
                                    ),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Color(0xff562A85),
                        minWidth: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.12,
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SquatTutorial(cameras: widget.cameras, level: '중급')));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whiteRusso('Squat', 18, false),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  whiteNoto('스쿼트', 14, false),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, color: Colors.white, size: 12,),
                                      whiteNoto('10분', 14, false),
                                    ],
                                  ),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Color(0xff562A85),
                        minWidth: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.12,
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SquatTutorial(cameras: widget.cameras, level: '고급' )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whiteRusso('Dumbbell Curl', 18, false),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  whiteNoto('덤벨 컬', 14, false),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, color: Colors.white, size: 12,),
                                      whiteNoto('10분', 14, false),
                                    ],
                                  ),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Color(0xff562A85),
                        minWidth: MediaQuery.of(context).size.width*0.8,
                        height: MediaQuery.of(context).size.height*0.12,
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SquatTutorial(cameras: widget.cameras, level: '고급' )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whiteRusso('Cross Jack', 18, false),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  whiteNoto('크로스잭', 14, false),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time, color: Colors.white, size: 12,),
                                      whiteNoto('10분', 14, false),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
