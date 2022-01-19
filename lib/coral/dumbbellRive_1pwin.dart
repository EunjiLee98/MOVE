import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class DumbbellRive_1pwin extends StatefulWidget {

  final int score_1p;
  final int score_2p;
  DumbbellRive_1pwin({required this.score_1p, required this.score_2p});

  @override
  _DumbbellRive_1pwinState createState() => _DumbbellRive_1pwinState();
}


class _DumbbellRive_1pwinState extends State<DumbbellRive_1pwin> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('dumbbellRive_1pwin.png'),
                fit: BoxFit.fill
            )
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height/3,),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(widget.score_1p.toString(), style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
                        TextButton(
                          child: Image.asset('dumbbellRive_home.png', width: MediaQuery.of(context).size.width/3,),
                          onPressed: () {
                            // SchedulerBinding.instance!.addPostFrameCallback((_) {
                            //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                            //       builder: (BuildContext context) =>
                            //           );
                            //   // Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(bluetoothServices: widget.bluetoothServices)));
                            // });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(widget.score_2p.toString(), style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
                        TextButton(
                          child: Image.asset('dumbbellRive_restart.png', width: MediaQuery.of(context).size.width/3,),
                          onPressed: () {
                            SchedulerBinding.instance!.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}

