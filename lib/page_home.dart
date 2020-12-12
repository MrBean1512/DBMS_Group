import 'package:flutter/material.dart';

import "task_list.dart";

//this is the Home page of the app
//it should show all of today's tasks

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildTaskList(DateTime.now(), DateTime.now(), context, _formKey, 'assets/images/4x/home_tasksxxxhdpi.png'),
    );
  }
}