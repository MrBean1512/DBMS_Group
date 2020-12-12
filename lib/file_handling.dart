//import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

//'select title from task_manager.task;'

import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '10.0.2.2',
      user = 'testuser',
      password = 'password',
      db = 'task_manager';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}

// Pre-fill the form with some default values. This is only temporary for the sake of code demonstration
Future<Map> getMapFromJson([DateTime start, DateTime end]) async {
  print("getMapFromJson");
  //Map data = await readData();
  //DateTime start = recStart;
  //DateTime end = recEnd;
  String query = 'select * from task_manager.task where ownerID = 1';
  if ((start != null && end != null) && (start.isBefore(end))) {
    start = start.subtract(Duration(hours: start.hour));
    start = start.subtract(Duration(minutes: start.minute));
    start = start.subtract(Duration(seconds: start.second));
    start = start.subtract(Duration(milliseconds: start.millisecond));
    start = start.subtract(Duration(microseconds: start.microsecond));

    end = end.add(Duration(hours: 23 - end.hour));
    end = end.add(Duration(minutes: 59 - end.minute));
    end = end.add(Duration(seconds: 59 - end.second));
    end = end.add(Duration(milliseconds: 999 - end.millisecond));
    end = end.subtract(Duration(microseconds: end.microsecond));

    query =
        "SELECT * FROM task_manager.task WHERE dateTime >= '$start' AND dateTime <= '$end' AND ownerID = 1;";
  } else {
    print(
        "There was a problem with the start and end dates in the query, showing all tasks for this user");
  }

  Map data = await getQuery(query);
  print(data);
  if (data == null) {
    //use the following commented code (jsonData) as for placeholder data
    data = {
      "id": [1, 2, 3, 4, 5],
      "title": [
        "an error occured",
        "these are placeholder tasks",
        "feed the dog",
        "call grandma",
        "start pork roast"
      ],
      "description": [
        "while retrieving the dbms data",
        "CS pg 349 and GE",
        "2 scoops of chow",
        " ",
        "add half brick of butter and some pepper"
      ],
      "dateTime": [
        "2020-12-12 20:00:00.000",
        "2020-12-12 20:00:00.000",
        "2020-12-12 20:00:00.000",
        "2020-12-20 20:00:00.000",
        "2020-12-20 20:00:00.000"
      ],
      "completed": [false, false, false, false, false]
    };
  }
  return data;
}




Map getMapFromJsonC() {
  //this is used for the calendar

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

/////////////////////////////////////////////////////////////////////////
//The following section contains file io related functions
/////////////////////////////////////////////////////////////////////////
//*important*
//methods in this section are not necessary for handling tasks in the
//application, avoid these if possible and dynamically update application
//directly with the dbms, this should only be used to store cookies
//and possibly custom settings as the app continues to develop


///write dbms data into json file
///note this does not currently function properly
populateJson([DateTime start, DateTime end]) {
  String query = 'select * from task_manager.task;';
  writeData(getQuery(query));
}

///get the local file path
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

///get the local file
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.json');
}

///write data into the file
Future<File> writeData(Future<Map> data) async {
  final file = await _localFile;

  // Write the file.
  print("write data");
  return file.writeAsString(jsonEncode(data));
}

///read data from the file
Future<Map> readData() async {
  try {
    final file = await _localFile;

    // Read the file.
    String contents = await file.readAsString();
    Map data = json.decode(contents);
    return (data);
  } catch (e) {
    // If encountering an error, return 0.
    return null;
  }
}

/////////////////////////////////////////////////////////////////////////
///The following section contains SQL related functions
/////////////////////////////////////////////////////////////////////////

///establish a connecion and submit a query to mySQL
Future<Results> performQueryOnMySQL(String query) async {
  print("performQueryOnMySQL");
  // Open a connection
  try {
    var settings = new ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: 'testuser', // test user to login into with using unsecure password
      password: "password",
      db: 'task_manager',
    );

    var conn = await MySqlConnection.connect(settings);

    //figured it would at least get here so i could see if it worked but i dont think it gets there
    if (conn == null) {
      print('ERROR - COULD NOT CONNECT TO DBMS');
    }

    var results = await conn.query(query);

    conn.close();
    return results;
  } catch (e) {
    print("ERROR WITH QUERY -> $e");
    return e;
  }
}

///send a query to the dbms and recieve the query table as a <map>
Future<Map> getQuery(String query) async {
  print("getQuery()");
  //query the dbms

  Results results = await performQueryOnMySQL(query);

  //initialize the map keys with the field keys
  Map tasks = {};
  //print(results.elementAt(0).fields.keys);
  for (var i = 0; i < results.elementAt(0).fields.keys.length; i++) {
    tasks[results.elementAt(0).fields.keys.elementAt(i)] = [];
    for (var row in results) {
      //print(row[i]);
      tasks[row.fields.keys.elementAt(i)].add(row[i]);
    }
  }
  //transfer values into map
  //for (var row in results) {
  //  print(row.values);
  //}
  return (tasks);
}
