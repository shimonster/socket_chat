import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './chat.dart';
import './auth.dart';
import './function/client.dart';
import './function/server.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCreating;
  String _username;
  ChangeNotifier _messagingService;

  void setData(bool newMode, String newName, int port) {
    _isCreating = newMode;
    _username = newName;
    if (newMode) {
      print('server');
      _messagingService = Server(_username, port);
    } else {
      print('client');
      _messagingService = Client(_username, port);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(_messagingService);
    return ChangeNotifierProvider.value(
      value: _messagingService == null ? ChangeNotifier() : _messagingService,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: _messagingService == null ? Auth(setData) : Chat(_isCreating),
      ),
    );
  }
}
