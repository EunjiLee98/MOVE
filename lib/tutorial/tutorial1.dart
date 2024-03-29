import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:camera/camera.dart';
import 'package:move/exercise/squatRive.dart';

//Squat tutorial
class Tutorial1 extends StatefulWidget {
  final List<CameraDescription> ? cameras;
  Tutorial1({this.cameras});

  @override
  _Tutorial1State createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;
  List<Widget>? tutorial;
  Stream<int> _bids = (() async* {
    yield 1;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 2;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 3;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 4;
    await Future<void>.delayed(const Duration(seconds: 2));
    yield 5;
  })();

  @override
  void dispose(){
    // _streamController.close();
    super.dispose();
  }

  ListView _buildConnectDeviceView() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
            child:Column(
              children: [
                SizedBox(height: 30,),
                Center(
                    child:Column(
                      children: [
                        StreamBuilder<int>(
                          stream: _bids,
                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                            if (!snapshot.hasData) {
                              return Text('Loading...');
                            }

                            if (snapshot.hasError) {
                              tutorial = <Widget>[
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                                ),
                              ];
                            } else {
                              switch (snapshot.data) {
                                case 1:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
                                      SizedBox(width: 110,),
                                      Image.asset('num1.png'),
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Stand shoulder-width",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white,),),
                                    Text("with toes slightly outward.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white,),),
                                    SizedBox(height: 20,),
                                    Image.asset('squat_1.png',height: 350,width: 280,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => Squat(
                                                cameras: widget.cameras!,
                                                title: 'MOVE! - Squat',
                                                //customModel: 'MOVE! - Squat',
                                              ),
                                            ),
                                            );
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 2:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
                                      SizedBox(width: 110,),
                                      Image.asset('num2.png'),
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Eyes forward, tighten your abs ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    Text("and tighten your waist.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    SizedBox(height: 20,),
                                    Image.asset('squat_2.png',height: 350,width: 280,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => Squat(
                                                cameras: widget.cameras!,
                                                title: 'MOVE! - Squat',
                                                //customModel: 'MOVE! - Squat',
                                              ),
                                            ),
                                            );
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 3:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
                                      SizedBox(width: 110,),
                                      Image.asset('num3.png'),
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Sit until your knees are",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    Text("level with your thighs,",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    Text("keeping them from moving",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    Text("forward beyond your toes.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    Image.asset('squat_1.png',height: 350,width: 280,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => Squat(
                                                cameras: widget.cameras!,
                                                title: 'MOVE! - Squat',
                                                //customModel: 'MOVE! - Squat',
                                              ),
                                            ),
                                            );
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 4:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
                                      SizedBox(width: 110,),
                                      Image.asset('num4.png'),
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Stand up with your thighs tightened",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    Text("feeling like you're pushing with your heels.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    SizedBox(height: 20,),
                                    Image.asset('squat_2.png',height: 350,width: 280,),
                                    Row(
                                      children: [
                                        SizedBox(width: 230,),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            primary: Colors.black,
                                            // foreground
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => Squat(
                                                cameras: widget.cameras!,
                                                title: 'MOVE! - Squat',
                                                //customModel: 'MOVE! - Squat',
                                              ),
                                            ),
                                            );
                                          },
                                          child: Image.asset('skip.png',height: 30,),
                                        ),
                                      ],
                                    ),
                                  ];
                                  break;
                                case 5:
                                  tutorial = <Widget>[
                                    Row(children: [
                                      IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
                                      SizedBox(width: 110,),
                                      Image.asset('num5.png'),
                                    ],),
                                    SizedBox(height: 20,),
                                    Text("Please shake the microchip once.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white,),),
                                    SizedBox(height: 20,),
                                    Image.asset('squat_1.png',height: 350,width: 280,),
                                    SizedBox(height: 30,),
                                    //Text("moving value:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white,),),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        primary: Colors.black,
                                        // foreground
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => Squat(
                                            cameras: widget.cameras!,
                                            title: 'MOVE! - Squat',
                                            //customModel: 'MOVE! - Squat',
                                          ),
                                        ),
                                        );
                                      },
                                      child: Image.asset('start.png',height: 60),
                                    ),
                                  ];
                                  break;
                              }
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: tutorial!,
                            );
                          },
                        ),
                      ],
                    )
                ),
              ],
            )
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('tutorial2_background.png'),
                  fit: BoxFit.fill
              )
          ),
          child: _buildConnectDeviceView()
      ),
    );
  }
}
