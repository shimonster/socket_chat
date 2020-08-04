import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './function/server.dart';

class Chat extends StatefulWidget {
  Chat(this.isCreate);

  final bool isCreate;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    print('cat build was run');
    final messageService = Provider.of<Server>(context);

    return Scaffold(
      body: SizedBox(
        height: 500,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: messageService.messages.length,
              itemBuilder: (ctx, i) {
                final mes = messageService.messages[i];
                return Container(
                  decoration: BoxDecoration(
                    color: mes['uid'] == messageService.uid
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                onSubmitted: (input) {
                  messageService.sendMessage(input);
                  print('submited chat text');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
