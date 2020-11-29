
//import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart';

//import 'dart:io';
//import 'dart:async';
//import 'dart:html';
import 'dart:core';
import 'dart:convert';

//TODO
//this will likely be a useful resource: https://dart.dev/tutorials/web/fetch-data
//add functions to...
//updata local data from remote database (alexis' stuff)
//push new tasks to alexis' database
  //delete old tasks
  //due to some limitations of the dateTime variable in dart, editing an existing task will add a new task and delete the old one
//handle shared tasks
  //leave currently shared tasks
  //add members to your current task

// Pre-fill the form with some default values. This is only temporary for the sake of code demonstration
Map populateFromJson() {
  final jsonDataAsString = '''{
    "title": ["take out trash", "do homework", "feed the dog", "call grandma", "start pork roast"],
    "description": [" ", "CS pg 349 and GE", "2 scoops of chow", " ", "add half brick of butter and some pepper"],
    "dateTime": ["2020-12-20 20:00:00Z", "2020-16-20 20:00:00Z", "2020-12-20 20:00:00Z", "2020-12-20 20:00:00Z", "2020-12-20 20:00:00Z"],
    "completed": [false, false, false, false, false]
  }''';

  Map jsonData = json.decode(jsonDataAsString);
  return jsonData;
}
