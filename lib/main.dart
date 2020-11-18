//Main.dart: Creation of app - intially linked to menu

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'file_handling.dart';

void main() {
  runApp(MaterialApp(
    title: "Legend of Brian",
    theme: new ThemeData(
      primaryColor: Colors.green[900], //change this color
    ),
    home: Home_page(), //create an instance of the menu
  ));
}


