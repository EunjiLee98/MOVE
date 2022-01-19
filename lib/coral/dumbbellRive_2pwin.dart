import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class DumbbellRive_2pwin extends StatefulWidget {

  final int score_1p;
  final int score_2p;
  DumbbellRive_2pwin({required this.score_1p, required this.score_2p});

  @override
  _DumbbellRive_2pwinState createState() => _DumbbellRive_2pwinState();
}


class _DumbbellRive_2pwinState extends State<DumbbellRive_2pwin> {

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
                image: AssetImage('dumbbellRive_2pwin.png'),
                fit: BoxFit.fill
            )
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height/3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding:  const EdgeInsets.only(left: 100),
                          child: Text(widget.score_1p.toString(), style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 20,),
                        TextButton(
                          child: Image.asset('dumbbellRive_home.png', width: MediaQuery.of(context).size.width/4,),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 150),
                          child: Text(widget.score_2p.toString(), style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 20,),
                        TextButton(
                          child: Image.asset('dumbbellRive_restart.png', width: MediaQuery.of(context).size.width/4,),
                          onPressed: () {
                            // SchedulerBinding.instance!.addPostFrameCallback((_) {
                            //   Navigator.pop(context);
                            // });
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

