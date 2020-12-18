//All functions in this file are related to querying the dbms or local storage

import 'package:path_provider/path_provider.dart';

import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:mysql1/mysql1.dart';

//this class is called in queries in order to
/*
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
*/

/////////////////////////////////////////////////////////////////////////
///The following section contains functions responsible for interacting
///with the dbms
/////////////////////////////////////////////////////////////////////////

///establish a connecion and submit a query to mySQL
Future<Results> performQueryOnMySQL(String query) async {
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
    //print("query: $query");
    var results = await conn.query(query);
    //print("results: $results");
    conn.close();
    return results;
  } catch (e) {
    print("ERROR WITH QUERY -> $e");
    return e;
  }
}

///send a query to the dbms and recieve the query table as a <map>
Future<Map> getQuery(String query) async {
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

///submit a query where no data is expected in return
void justQuery(String query) async {
  Map data = await getQuery(query);
  //print(data);
}

/////////////////////////////////////////////////////////////////////////
///The following section contains functions responsible for parsing out
///querys from the functions used throughout the application.
///These are the middle men between the app and the dbms.
/////////////////////////////////////////////////////////////////////////

///get a map of all the tasks for the current user
///start and end allow the app to optionally specify a time range
Future<Map> getTasks([DateTime start, DateTime end]) async {
  print("getMapQuery");

  //this string is used if no date range is specified
  String query =
      "SELECT DISTINCT T.ID as ID, T.title as title, T.description as description, "
      "T.dateTime as dateTime, T.completion as completion, C.name as category, "
      "Color.A as colorA, Color.R as colorR, Color.G as colorG, Color.B as colorB, "
      "T.ownerID as taskOwner, C.ownerID as categoryOwner, C.ID as categoryID "
      "FROM task_manager.task T "
      "inner join task_manager.category C ON T.categoryID = C.ID "
      "inner join task_manager.color ON C.color = color.color "
      "WHERE T.ownerID = 1 "
      "AND T.completion = false "
      "ORDER BY T.dateTime;";

  //if a date range is specified...
  if ((start != null && end != null) && (start.isBefore(end))) {
    //strip down the dateTime to the starting second of that day
    start = start;
    start = start.subtract(Duration(hours: start.hour));
    start = start.subtract(Duration(minutes: start.minute));
    start = start.subtract(Duration(seconds: start.second));
    start = start.subtract(Duration(milliseconds: start.millisecond));
    start = start.subtract(Duration(microseconds: start.microsecond));

    //strip down the dateTime to the ending second of that day
    end = end;
    end = end.add(Duration(hours: 23 - end.hour));
    end = end.add(Duration(minutes: 59 - end.minute));
    end = end.add(Duration(seconds: 59 - end.second));
    end = end.add(Duration(milliseconds: 999 - end.millisecond));
    end = end.subtract(Duration(microseconds: end.microsecond));

    //form the query based on the start and end dates
    query =
        "SELECT DISTINCT T.ID as ID, T.title as title, T.description as description, "
        "T.dateTime as dateTime, T.completion as completion, C.name as category, "
        "Color.A as colorA, Color.R as colorR, Color.G as colorG, Color.B as colorB, "
        "T.ownerID as taskOwner, C.ownerID as categoryOwner, C.ID as categoryID "
        "FROM task_manager.task T "
        "inner join task_manager.category C ON T.categoryID = C.ID "
        "inner join task_manager.color ON C.color = color.color "
        "WHERE T.dateTime >= '$start' "
        "AND DATE(dateTime) <= '$end' "
        "AND T.ownerID = 1 "
        "AND T.completion = false "
        "ORDER BY T.dateTime;";
  }

  print("getquery: $query");
  //recieve the query response from the dbms in the form of a table
  Map data = await getQuery(query);
  print(data);
  //dateTime fields recieved from the dbms are the correct tasks but for some
  //reason they are automatically converted to UTC. The following loop corrects
  //the data to show the right times
  for (int i = 0; i < data.entries.first.value.length; i++) {
    data["dateTime"][i] = data["dateTime"][i].toLocal();
  }

  //if something is broken and no response is recieved, then use the following
  //map in order to demo the application
  if (data == {}) {
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

///called when a new task form is submitted
void newFormQuery(String title, String description, int category,
    String strDateTime, int userID) {
  //dateTime is submitted as a string by the user, this converts it to a
  //DateTime type
  DateTime dateTime = DateTime.parse(strDateTime);

  //mySQL does not recognize microseconds in the same way as dart so I just
  //eliminate them altogether
  dateTime = dateTime.subtract(Duration(microseconds: dateTime.microsecond));
  String query =
      "INSERT INTO task (title, ownerID, description, dateTime, completion, recurringID, categoryID) "
      "VALUES ('$title', $userID, '$description', '$dateTime', false, 1, $category);";
  justQuery(query);
  print(query);
}

///used to update an existing task
void updateFormQuery(String title, String description, int category,
    String strDateTime, int taskID) {
  //dateTime is submitted as a string by the user, this converts it to a
  //DateTime type
  DateTime dateTime = DateTime.parse(strDateTime);

  //mySQL does not recognize microseconds in the same way as dart so I just
  //eliminate them altogether
  dateTime = dateTime.subtract(Duration(microseconds: dateTime.microsecond));
  String query = "UPDATE task SET "
      "title = '$title', "
      "description = '$description', "
      "categoryID = $category, "
      "dateTime = '$dateTime' "
      "WHERE task.ID = $taskID;";
  //print("updatequery: $query");
  justQuery(query);
  print(query);
}

//called when a task is checked off
///marks a task a complete so that it disappears from the user's view
void completeTask(bool value, int taskID) {
  print("update complete bool");
  String query = "UPDATE task_manager.task SET "
      "completion = $value "
      "WHERE task.ID = $taskID;";
  justQuery(query);
}

//called to retrieve the categories
//specifically used when creating or aditing a task
Future<Map> getCategories(int user) async {
  print("getCategories");
  String query =
      "SELECT Category.ID, Category.name, Category.color, Color.A, Color.R, Color.G, Color.B "
      "FROM task_manager.Category inner join task_manager.Color ON Category.color = Color.color "
      "WHERE Category.ownerID = $user; ";
  return await getQuery(query);
}

//called to validate the user's login
//retrieves the user's ID as well
Future<int> validateLogin(String username, String password) async {
  print("validateLogin");
  String query =
      "select ID from task_manager.user where username = '$username' AND password = '$password';";
  Results results = await performQueryOnMySQL(query);
  int userID = results.elementAt(0).values[0];
  print("userID: $userID");
  return userID;
}

//this is antiquated and only used for the placeholder text in the calendar
Map getMapFromJsonCal() {
  //this is used for the calendar

  final jsonDataAsString = '''{
      "id": [1, 2, 3, 4, 5],
      "title": ["these are dummy tasks", "do homework", "feed the dog", "call grandma", "start pork roast"],
      "description": [" ", "CS pg 349 and GE", "2 scoops of chow", " ", "add half brick of butter and some pepper"],
      "dateTime": ["2020-12-12 20:00:00.000", "2020-12-12 20:00:00.000", "2020-12-12 20:00:00.000", "2020-12-20 20:00:00.000", "2020-12-20 20:00:00.000"],
      "completed": [false, false, false, false, false]
  }''';

  Map<String, dynamic> jsonData = json.decode(jsonDataAsString);
  return jsonData;
}

/////////////////////////////////////////////////////////////////////////
//The following section contains file io related functions
/////////////////////////////////////////////////////////////////////////
//*important*
//methods in this section are not used for handling tasks in the
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
