import 'package:move/coral/dumbbellRive.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class JsonDataFromCoral {
  String? l0;
  String? l1;

  JsonDataFromCoral({this.l0, this.l1});

  JsonDataFromCoral.fromJson(Map<String, dynamic> json) {
    l0 = json['0'].cast<int>();
    l1 = json['1'].cast<int>();
  }

  Map<String, dynamic> toJson(Map<String, dynamic> data) {
    data['0'] = this.l0;
    data['1'] = this.l1;
    return data;
  }
}

class WebSocket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Dumbbell using Coral';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: WebSocketPage(
        title: title,
        channel: IOWebSocketChannel.connect('ws://192.168.0.13:9998'),
      ),
    );
  }
}

class WebSocketPage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  WebSocketPage({required this.title, required this.channel});

  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  TextEditingController _controller = TextEditingController();
  String? jsonData;
  String ? jsonDataConverted;
  List ? jsonList;
  var jsonDynamic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (context, snapshot) {
              jsonData = jsonEncode(snapshot.data.toString());
              //jsonDataConverted = json.decode(jsonData!);
              jsonList = jsonData!.split("end");
              //jsonDynamic = List<dynamic>.from(jsonList!);
              return Dumbbell(
                data : jsonList!,
              );
            },
          ),
        ],
      ),
    );
  }

  List convert(String input) {
    List output;
    output = json.decode(input);
    return output;
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(_controller.text);
    }
  }

  void _getMessage() {
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.toString();
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}