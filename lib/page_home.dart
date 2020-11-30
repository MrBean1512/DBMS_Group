import 'package:flutter/material.dart';

import "task_list.dart";

//this is the Home page of the app
//it should show all of today's tasks
class PageHome extends StatelessWidget {
  @override
  Widget build(BuildContext contect) {
    return Center(
      child: buildTaskList('assets/images/4x/home_tasksxxxhdpi.png'),
    );
  }
}