//import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart';

import 'package:mysql1/mysql1.dart';

import 'dart:io';
//import 'dart:async';
//import 'dart:html';
import 'dart:core';
import 'dart:convert';

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

// Pre-fill the form with some default values. This is only temporary for the sake of code demonstration
Map populateFromJson() {
  //final jsonDataAsString = new File('tasks.txt').readAsStringSync();

  final jsonDataAsString = '''{
      "id": [1, 2, 3, 4, 5],
      "title": ["these are dummy tasks", "do homework", "feed the dog", "call grandma", "start pork roast"],
      "description": [" ", "CS pg 349 and GE", "2 scoops of chow", " ", "add half brick of butter and some pepper"],
      "dateTime": ["2020-12-12 20:00:00.000", "2020-12-12 20:00:00.000", "2020-12-12 20:00:00.000", "2020-12-20 20:00:00.000", "2020-12-20 20:00:00.000"],
      "completed": [false, false, false, false, false]
  }''';

  //sqlConnect();

  Map<String, dynamic> jsonData = json.decode(jsonDataAsString);
  return jsonData;
}

void addNewTask(
    String title, String description, DateTime dateTime, String category) {}

void deleteTask(int id) {}

Future sqlGetJsonTasks() async {
  //connection configuration to log into database
  /*
  MySqlConnection.connect(ConnectionSettings(
          host: 'localhost',
          port: 3306,
          user: 'admin',
          password: '#1Dmartin21',
          db: 'task_manager'))
      .then((conn) {
    //Run and execute a query
    conn.query('SELECT * FROM Task.tasks').then((results) {
      List.from(results).forEach((row) {
        // waits a certain amount of time before printing a result. Necessary to give the system
        // enough time to do what it needs to before closing the program too early
        Future.delayed(const Duration(milliseconds: 1000), () {
          print('Name: ${row[0]}');
        });
      });

      if (File('tasks.txt').existsSync() == true) {
        File('tasks.txt').deleteSync();
      }
      new File('tasks.txt').createSync();

      conn.close(); // closing database connection here
    });
  });
  */
  var conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'admin',
      password: '#1Dmartin21',
      db: 'task_manager'));

  var results = await conn.query('SELECT FROM task');
  for (var row in results) {
    print('Name: ${row[0]}, email: ${row[1]}');
  }

  conn.close(); // closing database connection here
}

Future sqlAddData(String query) async {
  //connection configuration to log into database
  MySqlConnection.connect(ConnectionSettings(
          host: 'localhost',
          port: 3306,
          user: 'admin',
          password: '#1Dmartin21',
          db: 'task_manager'))
      .then((conn) {
    //Run and execute a query
    conn.query(query).then((results) {
      conn.close(); // closing database connection here
    });
  });
}
