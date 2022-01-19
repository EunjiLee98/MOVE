import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/front/gameSelect.dart';
import 'package:move/front/training.dart';
import '../reabilitation/reabilitation.dart';

class Select extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  final List<CameraDescription>? cameras;
  Select({this.bluetoothServices, this.cameras});

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //screen vertically
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
                image: AssetImage('background.png'),
                fit: BoxFit.fill
            )
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Training(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras)));
                  },
                  child: Image.asset('hwButton.png', width: MediaQuery.of(context).size.width*0.7,),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GameSelect(bluetoothServices: widget.bluetoothServices)));
                  },
                  child: Image.asset('gameButton.png', width: MediaQuery.of(context).size.width*0.7,),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Flexible(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ReabSelect(bluetoothServices: widget.bluetoothServices, cameras: widget.cameras,)));
                    },
                    child: Image.asset('reabButton.png', width: MediaQuery.of(context).size.width*0.7,)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}