//Main.dart: Creation of app - intially linked to menu

import 'package:flutter/material.dart';
import 'app_page.dart';
import 'page_login.dart';
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
      //home: AppPage(title: 'Task Manager'),
      home: PageLogin(title: 'Task Manager'),
    );
  }
}

/*
TODO
this will likely be a useful resource: https://dart.dev/tutorials/web/fetch-data
share categories
  search users and send invite
    invite by chooseing category
  accept or deny invites
tasks forms
  choose category
    choose color
    choose category
      add new category
  make all tasks show due date and time
  make all task boxes show category color
page today
  add "today" header
page calendar
  show task due time
  optionally add editing features to it
  optionally remove viewing options and insert calendar into list widget
page agenda
  add '2 days' view button
  add '1 week' view button
  add 'category' view button
    optionally use '2 week' view button if time doesn't permit this
*/
