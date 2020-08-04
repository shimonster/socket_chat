import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  Auth(this.setCreate);

  final void Function(bool, String, int) setCreate;
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _isCreating = true;
  final _nameController = TextEditingController();
  final _portController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _portController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Chat Id',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: _isCreating ? 13 : 10,
                    child: RaisedButton(
                      child: Text('Create'),
                      elevation: _isCreating ? 15 : null,
                      color: _isCreating
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColorLight,
                      onPressed: () {
                        setState(() {
                          _isCreating = true;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: _isCreating ? 10 : 13,
                    child: RaisedButton(
                      child: Text('Join'),
                      elevation: _isCreating ? null : 15,
                      color: _isCreating
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isCreating = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              RaisedButton(
                child: Text(
                  'Chat',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColorDark,
                onPressed: () {
                  widget.setCreate(_isCreating, _nameController.text,
                      int.parse(_portController.text));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
