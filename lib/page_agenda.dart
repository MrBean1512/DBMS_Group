import 'package:flutter/material.dart';

import "task_list.dart";

//this is the agenda page of the app
//it should show a list of upcoming tasks as specified by the user
class PageAgenda extends StatelessWidget {
  @override
  Widget build(BuildContext contect) {
    return Center(
      child: buildTaskList(),
    );
  }
}