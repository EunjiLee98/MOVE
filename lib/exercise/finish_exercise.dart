import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';
import 'package:move/theme/font.dart';

class FinishExercise extends StatelessWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  FinishExercise({this.bluetoothServices, this.cameras});

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
                SizedBox(height: 30,),
                Stack(
                  children: [
                    Lottie.asset(
                      'assets/finish.json',
                      repeat: true,
                      reverse: false,
                      animate: true,
                      height: 300,
                      width: 300,
                    ),
                    Column(
                      children: [
                        SizedBox(width: 300, height:120),
                        Image.asset('finish1.png'),
                      ],
                    ),
                  ],
                ),
                Center(child:
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        // foreground
                      ),
                      onPressed: () {
                        // addScore(score);
                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         Homepage(bluetoothServices: widget.bluetoothServices)), (route) => false);
                      },
                      child: Image.asset('homeButton.png',height: 72,),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        // foreground
                      ),
                      onPressed: () {
                        // addScore(score);
                        // Navigator.pop(context);
                      },
                      child: Image.asset('restart.png',height: 72,),
                    ),
                  ],
                ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
