//sources:
//used this package to help handle date/time selections
//https://pub.dev/packages/datetime_picker_formfield

import 'package:flutter/material.dart';

import 'forms.dart';
import "file_handling.dart";

//multiple pages implement ListViews so this is used for them all

//builds a listView widget of tasks

FutureBuilder buildTaskList(DateTime start, DateTime end, context, _formKey,
    [String imageFile]) {
  //image is optional
  Map tasks;
  //Map tasks = getMapFromJson(start, end); //Map is created from json file
  return (FutureBuilder(
      future: getTasks(start, end),
      builder: (context, projectSnap) {
        /*
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        */
        if (!projectSnap.hasData) {
          print("not showing calendar");
          return Container();
        } else
          return (ListView.separated(
            //begin construction of actual widget
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: projectSnap.data.entries.first.value.length + 1,
            //number of widgets to create, used by index
            //this is the same as tasks.entries.first.value.length
            itemBuilder: (context, index) {
              //iterate through Map to make task objects
              if (index == 0) {
                //if it's the first iteration of the loop
                if (imageFile != null) {
                  //if an image has been specified
                  return (Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Image.asset(imageFile),
                  ));
                } //if no image was specified index
                else
                  return (Container());
              }

              /*
            return buildTaskBox(context, _formKey, tasks, tasks['title'][index - 1],
              tasks['description'][index - 1], tasks['dateTime'][index - 1]);
            */
              return buildTaskBox(
                  context, _formKey, projectSnap.data, index - 1);
              //return statements return only to itemBuilder
            },

            separatorBuilder: (BuildContext context, int index) =>
                const Divider(), //just visually divides task boxes
          ));
      }));
}

//builds a taskBox container
//intended to be used by buildTaskList()
InkWell buildTaskBox(context, _formKey, Map tasks, int taskIndex) {
  return (InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    /*
                    this was just an x button but clicking outside the screen is pretty intuitive
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    */
                    EditTaskForm(tasks, taskIndex),
                    Positioned(
                      right: -40.0,
                      bottom: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.delete),
                          backgroundColor: Colors.red[100],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Color.fromARGB(80, tasks["colorR"][taskIndex],
            tasks["colorG"][taskIndex], tasks["colorB"][taskIndex]),
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
                      //title, //this is where the title string is used
                      tasks["title"][taskIndex],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    //description, //this is where the description string is used
                    tasks["description"][taskIndex],
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )));
}
