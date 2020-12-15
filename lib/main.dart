/*
Main.dart:
Initializes app.
The page_app acts as the main scaffold for the whole app but the user must pass
login authentication first via page_login.
For some more details about the nature of widgets, look at page_app.dart
*/


import 'package:flutter/material.dart';
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
      //home: AppPage(title: 'Task Manager'),
      home: PageLogin(title: 'Task Manager'),
    );
  }
}


MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
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
