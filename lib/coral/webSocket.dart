import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          //crossAxisAlignment: CrossAxisAlignment.start,
            child:
            //ren: <Widget>[
            // Form(
            //   child: TextFormField(
            //     controller: _controller,
            //     decoration: InputDecoration(labelText: 'Send a message'),
            //   ),
            // ),
            StreamBuilder(
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return SingleChildScrollView(
                  //padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data.toString()}' : ''),
                );
              },
            )
          // ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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