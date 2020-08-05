// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// void main() {
//   Client('bob', 1234).startClient();
// }

class Uid extends UniqueKey {
  @override
  String toString() {
    return shortHash(this).toString();
  }
}

class Client extends ChangeNotifier {
  Client(this.username, this.port);

  final String username;
  final int port;
  final uid = Uid().toString();
  WebSocket ws;
  List<Map<String, String>> messages = [];

  void startClient() {
    print('client started');
    final address = 'ws://localhost:1234/$uid';
    ws = WebSocket(address);
    print('client connected to ws');
    if (ws.readyState != WebSocket.CLOSED ||
        ws.readyState != WebSocket.CLOSING) {
      print('after threads');
      ws.onMessage.listen(
        (event) {
          print(
              '${DateTime.now()}, ${Map<String, String>.from(json.decode(event.data))}');
          messages.add(Map<String, String>.from(json.decode(event.data)));
          print('after add');
          notifyListeners();
        },
        onDone: () => print('listening to seb socket finished'),
        onError: (error) =>
            print('client error listening to web socket: $error'),
        cancelOnError: true,
      );
    }
  }

  void sendMessage(String message) {
    print('sending message from client');
    messages.add({'message': message, 'name': username, 'uid': uid});
    ws.send(json.encode({'message': message, 'name': username, 'uid': uid}));
    notifyListeners();
  }
}
