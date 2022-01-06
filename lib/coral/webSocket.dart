import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:queue/queue.dart';

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
    final title = 'WebSocket between Coral and Flutter';
    return MaterialApp(
      title: title,
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
  String? jsonDataConverted;
  String? newResult;
  var newJsonList;
  List result = [];

  makeList(List result) {
    List x = [];
    for(int i=0; i < result.length; i++)
      {
        print(result[i]);
      }
    return x;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: widget.channel.stream,
            builder: (context, snapshot) {
              // if (jsonData != null && jsonDataConverted != null) {
              jsonData = jsonEncode(snapshot.data.toString());
              jsonDataConverted = json.decode(jsonData!);
              //List<String> result = jsonList.split('\n');
              result = jsonDataConverted!.split(' ');
              //newResult = makeList(result);
              //newJsonList[0] = jsonList[0];
              //jsonDataConverted = jsonDecode(jsonData!);
              //var jsonDataList =  JsonDataFromCoral.fromJson(jsonDataConverted!);
              //print(jsonDataList);
              //}
              return Column(
                children: [
                  //Text(snapshot.hasData ? '${snapshot.data.toString()}' : ''),
                  Text(jsonDataConverted.toString()),
                  Text(result[0]),
                  Text(result[1]),
                  // Text(result[2]),
                  // Text(result[3]),
                  // Text(result[4]),
                  // Text(result[5]),
                ],
              );
            },
          ),
        ],
      ),
    );
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
