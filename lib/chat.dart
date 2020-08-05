// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';

import './function/server.dart';
import './function/client.dart';

class Chat extends StatefulWidget {
  Chat({this.messageClient, this.messageServer});

  final Server messageServer;
  final Client messageClient;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.messageClient != null) {
      widget.messageClient.startClient();
    } else {
      widget.messageServer.startServer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic _messageService =
        (widget.messageServer ?? widget.messageClient);
    print('cat build was run');
    _messageService.addListener(() {
      setState(() {});
    });

    return Scaffold(
      body: SizedBox(
        height: window.innerHeight.toDouble(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: window.innerHeight.toDouble() - 100,
              child: ListView.builder(
                itemCount: _messageService.messages.length,
                itemBuilder: (ctx, i) {
                  final mes = _messageService.messages[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: mes['uid'] == _messageService.uid
                          ? Colors.yellow[300]
                          : Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(mes['message']),
                      subtitle: Text(mes['name']),
                    ),
                  );
                },
              ),
            ),
            TextField(
              onSubmitted: (input) {
                _messageService.sendMessage(input);
                print('submited chat text');
              },
              onEditingComplete: () {
                print(_messageController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
