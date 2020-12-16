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
  DateTime endDate;

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now().add(Duration(days: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(height: 16,),
      _buildButtons(),
      Expanded(
          // wrap in Expanded
          child: buildTaskList(DateTime.now(), endDate, context)),
    ]);
  }

  Widget _buildButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          color: Colors.white,
          child: Text('2 Days'),
          onPressed: () {
            setState(() {
              endDate = DateTime.now().add(Duration(days: 2));
            });
          },
        ),
        Container(width: 16),
        RaisedButton(
          color: Colors.white,
          child: Text('1 Week'),
          onPressed: () {
            setState(() {
              endDate = DateTime.now().add(Duration(days: 7));
            });
          },
        ),
        Container(width: 16),
        RaisedButton(
          color: Colors.white,
          child: Text('2 Weeks'),
          onPressed: () {
            setState(() {
              endDate = DateTime.now().add(Duration(days: 14));
            });
          },
        ),
      ],
    );
  }
}
