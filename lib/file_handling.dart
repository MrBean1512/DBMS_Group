/*
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:async';

class Storage {

  //returns the path in which data for the game is stored
  Future<String> get localPath async {
    final dir= await getApplicationDocumentsDirectory();
    return dir.path;
  }

  //returns the file in which the data for the game is stored
  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  //returns the data in the file as a story object
  Future<Data> readData() async{
    try{
      final file = await localFile;
      Data body = (await file.readAsString()) as Data;
      return body;
    }
    catch (e) {
      return e.toString() as Data;
    }
  }

  //writes the data of the story object as a string into the file and returns the file
  Future<File> writeData(Data data) async {
    final file = await localFile;
    return file.writeAsString("$data");
  }
}
*/