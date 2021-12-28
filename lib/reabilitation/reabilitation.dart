import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/reabilitation/pushed_page.dart';

class ReabSelect extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  ReabSelect({this.bluetoothServices, this.cameras});

  @override
  _ReabSelectState createState() => _ReabSelectState();
}

class _ReabSelectState extends State<ReabSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Stretching', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0.0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {Navigator.pop(context);},
        ),
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PushedPage(
                          cameras: widget.cameras!,
                          title: 'posenet',
                          name: 'Warrior',
                        ),
                      ));
                    },
                    child: Image.asset('warriorButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  // SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PushedPage(
                          cameras: widget.cameras!,
                          title: 'posenet',
                          name: 'Tree',
                        ),
                      ));
                    },
                    child: Image.asset('treeButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                  // SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PushedPage(
                          cameras: widget.cameras!,
                          title: 'posenet',
                          name: 'Bow',
                        ),
                      ));
                    },
                    child: Image.asset('bowButton.png', width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      ),
    );
  }
}
