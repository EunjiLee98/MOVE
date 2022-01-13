import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:move/tutorial/tutorial2.dart';
import 'package:rive/rive.dart' as rive;

class Jumpingjack extends StatefulWidget {
  final List<BluetoothService>? bluetoothServices;
  Jumpingjack({this.bluetoothServices});

  @override
  _JumpingjackState createState() => _JumpingjackState();
}

class _JumpingjackState extends State<Jumpingjack> {
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String gesture = "";
  // ignore: non_constant_identifier_names
  int gesture_num = 0;

  late rive.RiveAnimationController _controller;
  late rive.RiveAnimationController _openController;

  @override
  void initState() {
    super.initState();
    _controller = rive.SimpleAnimation('Idle');

    _openController = rive.OneShotAnimation(
      'Jumpingjack',
      autoplay: false,
    );
  }

  ListView _buildConnectDeviceView() {
    // ignore: deprecated_member_use
    List<Container> containers = [];
    for (BluetoothService service in widget.bluetoothServices!) {
      // ignore: deprecated_member_use
      List<Widget> characteristicsWidget = [];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          characteristic.value.listen((value) {
            readValues[characteristic.uuid] = value;
          });
          characteristic.setNotifyValue(true);
        }
        if (characteristic.properties.read && characteristic.properties.notify) {
          setnum(characteristic);
        }
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Center(child:Text("블루투스 연결설정")),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: rive.RiveAnimation.asset(
            'assets/rive/move_jumpingjack.riv',
            controllers: [_controller, _openController],
          ),
        ),
      ],
    );
  }

  Future<void> setnum(characteristic) async {
    var sub = characteristic.value.listen((value) {
      setState(() {
        readValues[characteristic.uuid] = value;
        gesture = value.toString();
        gesture_num = int.parse(gesture[1]);
      });
    });

    if(gesture_num == 3 || gesture_num == 1) {
      setState(() {
        _openController.isActive = true;
        gesture_num = 0;
      });
    }

    await characteristic.read();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff37384E), const Color(0xff53304C)],
            ),
          ),
          child: _buildConnectDeviceView()
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:move/tutorial/tutorial2.dart';
//
// class Jumpingjack extends StatefulWidget {
//   final List<BluetoothService>? bluetoothServices;
//   Jumpingjack({this.bluetoothServices});
//
//   @override
//   _JumpingjackState createState() => _JumpingjackState();
// }
//
// class _JumpingjackState extends State<Jumpingjack> {
//   final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
//   String gesture = "";
//   // ignore: non_constant_identifier_names
//   int gesture_num = 0;
//
//   @override
//   void dispose(){
//     // _streamController.close();
//     super.dispose();
//   }
//
//   ListView _buildConnectDeviceView() {
//     // ignore: deprecated_member_use
//     List<Container> containers = [];
//     for (BluetoothService service in widget.bluetoothServices!) {
//       // ignore: deprecated_member_use
//       List<Widget> characteristicsWidget = [];
//
//       for (BluetoothCharacteristic characteristic in service.characteristics) {
//         if (characteristic.properties.notify) {
//           characteristic.value.listen((value) {
//             readValues[characteristic.uuid] = value;
//           });
//           characteristic.setNotifyValue(true);
//         }
//         if (characteristic.properties.read && characteristic.properties.notify) {
//           setnum(characteristic);
//         }
//       }
//       containers.add(
//         Container(
//           child: ExpansionTile(
//               title: Center(child:Text("블루투스 연결설정")),
//               children: characteristicsWidget),
//         ),
//       );
//     }
//
//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         Container(
//             child:Column(
//               children: [
//                 SizedBox(height: 30,),
//                 Center(
//                     child:Column(
//                       children: [
//                         Row(children: [
//                           IconButton(onPressed:(){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,))
//                         ],),
//                         SizedBox(height: 60,),
//                         Image.asset('snap.png',height: 200,),
//                         //Text("값:" + gesture_num.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                         SizedBox(height: 30,),
//                         Text("Please attach the chip",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
//                         Text("to your wrist",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),),
//                         Row(
//                           children: [
//                             SizedBox(width: 70,),
//                             TextButton(
//                               style: TextButton.styleFrom(
//                                 primary: Colors.black,
//                                 // foreground
//                               ),
//                               onPressed: () {
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => Tutorial2(bluetoothServices: widget.bluetoothServices)));
//                               },
//                               child: Image.asset('ok.png'),
//                             ),
//                           ],
//                         )
//                       ],
//                     )
//                 ),
//               ],
//             )
//         ),
//       ],
//     );
//   }
//
//   Future<void> setnum(characteristic) async {
//     var sub = characteristic.value.listen((value) {
//       setState(() {
//         readValues[characteristic.uuid] = value;
//         gesture = value.toString();
//         gesture_num = int.parse(gesture[1]);
//       });
//     });
//
//     await characteristic.read();
//     sub.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('tutorial1_background.png'),
//                   fit: BoxFit.fill
//               )
//           ),
//           child: _buildConnectDeviceView()
//       ),
//     );
//   }
// }