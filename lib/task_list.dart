import 'package:flutter/material.dart';

import "file_handling.dart";

//multiple pages implement ListViews so this is used for them all

//builds a listView widget of tasks
ListView buildTaskList([String imageFile]) {
  //image is optional
  Map tasks = populateFromJson(); //Map is created from json file
  return (ListView.separated(
    //begin construction of actual widget
    padding: const EdgeInsets.all(8),
    itemCount: 4, //number of widgets to create, used by index

    itemBuilder: (BuildContext context, int index) {
      //iterate through Map to make task objects
      if (index == 0) {
        //if it's the first iteration of the loop
        if (imageFile != null) {
          //if an image has been specified
          return Padding(
            padding: EdgeInsets.all(32.0),
            child: Image.asset(imageFile),
          );
        } //if no image was specified index
        index = index + 1;
      }

      return buildTaskBox(tasks['title'][index - 1],
          tasks['description'][index - 1], tasks['dateTime'][index - 1]);
      //return statements return only to itemBuilder
    },

    separatorBuilder: (BuildContext context, int index) =>
        const Divider(), //just visually divides task boxes
  ));
}

//builds a taskBox container
//intended to be used by buildTaskList()
Container buildTaskBox(String title, String description, String dateTime) {
  return Container(
    padding: const EdgeInsets.all(32),
    color: Colors.green[50],
    child: Row(
      children: [
        Icon(
          //dart conveniently provides premade icons, this will be useful so
          Icons.check_box,
          color: Colors.white,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title, //this is where the title string is used
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                description, //this is where the description string is used
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
