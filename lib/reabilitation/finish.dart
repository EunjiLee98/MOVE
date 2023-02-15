import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:move/exercise/squatRive.dart';
import 'package:move/front/home.dart';
import 'package:move/theme/font.dart';

class Finish extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String? name;
  final String? level;

  Finish({this.cameras, this.name, this.level});

  @override
  _FinishState createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('tutorial1_background.png'),
                  fit: BoxFit.fill
              )
          ),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
              SizedBox(height: 10,),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/finish.json',
                      repeat: true,
                      reverse: false,
                      animate: true,
                      width: MediaQuery.of(context).size.width*0.8,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 30,
                    child: Container(
                      width: 300,
                      child: Image.asset('finish1.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          whiteNoto('2월 15일 운동', 15, true),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              navyRusso(widget.name!, 20, false),
                              navyNoto(widget.level! + '세트', 17, true),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              whiteNoto('감량 칼로리', 15, true),
                              SizedBox(height: 5,),
                              whiteNoto('운동 시간', 15, true),
                              SizedBox(height: 5,),
                              whiteNoto('얻은 포인트', 15, true),
                            ],
                          ),
                          Center(
                              child: Container(
                                width: 1,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white
                                ),
                              )
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              whiteRusso('50', 20, false),
                              // SizedBox(height: 5,),
                              widget.level == '초급'
                                  ? whiteRusso('05:00', 20, false)
                                  : widget.level == '중급'
                                    ? whiteRusso('10:00', 20, false)
                                    : whiteRusso('20:00', 20, false),
                              // SizedBox(height: 5,),
                              whiteRusso('5', 20, false),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              whiteRusso('kcal', 12, false),
                              SizedBox(height: 10,),
                              whiteRusso('min', 12, false),
                              SizedBox(height: 10,),
                              whiteRusso('p', 12, false),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60,),
              Center(
                  child: GestureDetector(
                    onTap: () {
                      SchedulerBinding.instance!.addPostFrameCallback((_) {
                        // Navigator.pop(context);
                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>
                        //     Temp(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras, index: 1)), (route) => false);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white)
                            )
                        ),
                        child: whiteNoto('다른 운동 하러가기', 15, true)
                    ),
                  )
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // SchedulerBinding.instance!.addPostFrameCallback((_) {
                      //   // Navigator.pop(context);
                      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>
                      //       Temp(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras, index: 0)), (route) => false);
                      // });
                    },
                    child: Image.asset('homeButton.png', width: MediaQuery.of(context).size.width*0.43,),
                  ),
                  GestureDetector(
                    onTap: () {
                      // SchedulerBinding.instance!.addPostFrameCallback((_) {
                      //   // Navigator.pop(context);
                      //   if(widget.name == 'Jumping Jack')
                      //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>
                      //         Jumpingjack(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras)), (route) => false);
                      //   else if(widget.name == 'Squat')
                      //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) =>
                      //         Squat(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras, title: 'MOVE! - Squat Rive',)), (route) => false);
                      // });
                    },
                    child: Image.asset('restart.png', width: MediaQuery.of(context).size.width*0.43,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}