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
      //buildTaskList pretty much builds the entire home page
      child: buildTaskList(DateTime.now(), DateTime.now(), context, 'assets/images/4x/home_tasksxxxhdpi.png'),
    );
  }
}