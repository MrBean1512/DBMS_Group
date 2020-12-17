/*
Main.dart:
Initializes app.
The page_app acts as the main scaffold for the whole app but the user must pass
login authentication first via page_login.
For some more details about the nature of widgets, look at page_app.dart
*/

import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'page_login.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'task_list.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MaterialApp(
  //dateFormatting is used for the calendar page
  //and must be initialized before running the app
        home: App(), //create an instance of the application
      )));
}

class App extends StatelessWidget {
  // This widget is the root of your application.
    @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text(
        'Task Manager',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset(
          'assets/images/4x/splashscreen.png'),
      backgroundColor: Colors.white,
      loaderColor: Colors.red,
    );
  }
}

class AfterSplash extends StatelessWidget {
   // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running the application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: createMaterialColor(Color.fromARGB(255, 57, 55, 77)),
        buttonColor: createMaterialColor(Color.fromARGB(255, 108, 95, 255)),
      ),
      home: PageLogin(title: 'Task Manager'),
    );
  }
}

/*
TODO
this will likely be a useful resource: https://dart.dev/tutorials/web/fetch-data
deal with utc stuff
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
