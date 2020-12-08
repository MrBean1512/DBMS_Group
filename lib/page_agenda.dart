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
    return Center(
      child: buildTaskList(context, _formKey),
    );
  }
}