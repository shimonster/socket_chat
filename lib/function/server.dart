import 'dart:async';
import 'dart:io' show WebSocket, HttpServer, WebSocketTransformer;
import 'dart:convert';

import 'package:flutter/material.dart';

class Server extends ChangeNotifier {
  Server(this.username, this.port);

  final String username;
  final int port;
  final String uid = UniqueKey().toString();
  List<Map<String, String>> messages = [];
  Map<String, WebSocket> clientSockets = {};
  final messageStreamController = StreamController<List<Map<String, String>>>();
  Stream get messageStream {
    return messageStreamController.stream;
  }

  void startClient() {
    messageStreamController.addStream(Stream.value(messages));
    print('server started');
    HttpServer.bind('localhost', port).then((server) {
      print('after threads');
      server.listen((request) {
        final uid = request.uri.pathSegments[0];
        WebSocketTransformer.upgrade(request).then(
          (ws) {
            print('a client connected to ws');
            clientSockets.putIfAbsent(uid, () => ws);
            if (ws.readyState == WebSocket.open) {
              ws.listen(
                (event) {
                  print('$event');
                  messages.add(json.decode(event));
                  clientSockets.forEach((key, value) {
                    if (key != uid) {
                      value.add(event);
                    }
                  });
                },
                onDone: () {
                  print('listening to seb socket finished');
                  clientSockets.remove(uid);
                },
                onError: (error) {
                  print('client error listening to web socket: $error');
                  clientSockets.remove(uid);
                },
                cancelOnError: true,
              );
            }
          },
          onError: (error) =>
              print('client error contacing web socker: $error'),
        );
      });
    });
  }

  void sendMessage(String message) {
    final map = {'message': message, 'name': username, 'uid': uid};
    messages.add(map);
    clientSockets.forEach((uid, ws) {
      messageStreamController.add(messages);
      ws.add(json.encode(map));
    });
    notifyListeners();
  }
}
