//Main.dart: Creation of app - intially linked to menu

import 'package:flutter/material.dart';
import 'app_page.dart';
import 'file_handling.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  //populateJson();
  //getQuery('select * from task_manager.task;');
  initializeDateFormatting().then((_) => runApp(MaterialApp(
        home: App(), //create an instance of the menu
  )));
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: AppPage(title: 'Task Manager'),
    );
  }
}

/*
TODO
this will likely be a useful resource: https://dart.dev/tutorials/web/fetch-data
sql
  getQuery()
    write to json
  submitQuery()
file handling
  write query to a json file
    maybe write the query to a map and then map to json
  retrieve a map from the json file
task managing
  add a new task
  edit an existing task
    delete existing task and then add new one
    complete a task, change the color, change description or title
  delete a task
finish ui
  page today
    add "today" header
    only show today's tasks
  page calendar
    try to have it use the task Map
    show task description and due time
    optionally add editing features to it
    optionally remove viewing options and insert calendar into list widget
  page agenda
    add '2 days' view button
    add '1 week' view button
    add 'category' view button
      optionally use '2 week' view button if time doesn't permit this
*/
