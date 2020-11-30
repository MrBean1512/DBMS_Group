//Main.dart: Creation of app - intially linked to menu

import 'package:flutter/material.dart';
import 'app_page.dart';
import 'file_handling.dart';

void main() {
  runApp(MaterialApp(
    home: App(), //create an instance of the menu
  ));
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
