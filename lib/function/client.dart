import 'dart:io' show WebSocket;
import 'dart:convert';

import 'package:flutter/material.dart';

class Client extends ChangeNotifier {
  Client(this.username, this.port);

  final String username;
  final int port;
  final uid = UniqueKey().toString();
  WebSocket ws;
  List<Map<String, String>> messages = [];

  void startServer() {
    print('client started');
    final address = 'ws://localhost:$port/$uid';
    WebSocket.connect(address).then(
      (webS) {
        print('client connected to ws');
        print(webS.readyState);
        if (webS.readyState == WebSocket.open) {
          print('after threads');
          ws = webS;
          webS.listen(
            (event) {
              print(
                  '${DateTime.now()}, ${Map<String, String>.from(json.decode(event))}');
              messages.add(json.decode(event));
            },
            onDone: () => print('listening to seb socket finished'),
            onError: (error) =>
                print('client error listening to web socket: $error'),
            cancelOnError: true,
          );
        }
      },
      onError: (error) => print('client error contacing web socker: $error'),
    );
  }

  void sendMessage(String message) {
    messages.add({'message': message, 'name': username, 'uid': uid});
    ws.add(json.encode({'message': message, 'name': username, 'uid': uid}));
    notifyListeners();
  }
}
