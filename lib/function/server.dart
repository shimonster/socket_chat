import 'dart:io';
import 'dart:convert';

void main() {
  Server('bob', 1234).startServer();
}

class Server {
  Server(this.username, this.port);

  final String username;
  final int port;
  List<Map<String, String>> messages = [];
  Map<String, WebSocket> clientSockets = {};

  void startServer() {
    print('server started');
    HttpServer.bind('localhost', 1234).then((server) {
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
                  messages.add(Map<String, String>.from(json.decode(event)));
                  clientSockets.forEach((key, value) {
                    print('from outside if $key');
                    if (key != uid) {
                      print(key);
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

  // void sendMessage(String message) {
  //   print('sending message from server');
  //   final map = {'message': message, 'name': username, 'uid': uid};
  //   messages.add(map);
  //   clientSockets.forEach((uid, ws) {
  //     ws.add(json.encode(map));
  //   });
  //   notifyListeners();
  // }
}
