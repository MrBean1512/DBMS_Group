import 'package:flutter/material.dart';

import "task_list.dart";

//this is the agenda page of the app
//it should show a list of upcoming tasks as specified by the user

class PageAgenda extends StatefulWidget {
  @override
  _PageAgendaState createState() => _PageAgendaState();
}

class _PageAgendaState extends State<PageAgenda> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildButtons(),
      Expanded(
          // wrap in Expanded
          child:
              buildTaskList(DateTime.now(), DateTime.now(), context, _formKey)),
    ]);
  }

  Widget _buildButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          child: Text('2 Days'),
          onPressed: () {
            setState(() {});
          },
        ),
        RaisedButton(
          child: Text('1 Week'),
          onPressed: () {
            setState(() {});
          },
        ),
        RaisedButton(
          child: Text('2 Weeks'),
          onPressed: () {
            setState(() {});
          },
        ),
      ],
    );
  }
}
