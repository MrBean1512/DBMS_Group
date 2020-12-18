import 'package:flutter/material.dart';

import 'forms.dart';
import 'sql.dart';

//multiple pages implement ListViews so this is used for them all

//builds a listView widget of tasks

FutureBuilder buildTaskList(DateTime start, DateTime end, context,
    [String imageFile]) {
  //image is optional
  //Map tasks;
  //map is now created asyncronously in the futurebuilder as projectsnap.data
  return (FutureBuilder(
      future: getTasks(start, end),
      builder: (context, projectSnap) {
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
              return TaskBox(
                  context: context,
                  tasks: projectSnap.data,
                  taskIndex: index - 1);
              //return statements return only to itemBuilder
            },

            separatorBuilder: (BuildContext context, int index) =>
                const Divider(), //just visually divides task boxes
          ));
      }));
}

//builds a taskBox container
//intended to be used by buildTaskList()
class TaskBox extends StatefulWidget {
  TaskBox({this.context, this.tasks, this.taskIndex});
  final context;
  final Map tasks;
  final int taskIndex;

  @override
  TaskBoxState createState() {
    return TaskBoxState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class TaskBoxState extends State<TaskBox> {
  var context;
  var tasks;

  //used for the check-box state
  var complete = false;
  var icon = Icons.circle;
  Color iconColor = Colors.grey[300];
  var buttonColor = (Colors.white);

  //used to parse the time from dateTime
  var ampm = "am";
  String time;

  @override
  void initState() {
    super.initState();
    //initialize values
    context = widget.context;
    tasks = widget.tasks;

    //parse the time string
    if (tasks["dateTime"][widget.taskIndex].hour > 12) {
      ampm = "pm";
    }
    if (tasks["dateTime"][widget.taskIndex].minute < 9) {
      time =
          "${tasks["dateTime"][widget.taskIndex].hour % 12}:0${tasks["dateTime"][widget.taskIndex].minute} $ampm";
    } else {
      time =
          "${tasks["dateTime"][widget.taskIndex].hour % 12}:${tasks["dateTime"][widget.taskIndex].minute} $ampm";
    }
  }

  //build the task box
  @override
  Widget build(BuildContext context) {
    return (
        //inkwell makes the entire taskbox clickable for for updating the form
        InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          EditTaskForm(tasks, widget.taskIndex),
                          Positioned(
                            right: -40.0,
                            bottom: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                                // if the outside is clicked the form is papped
                                //back to the task view
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
            //create the visual layout of the task box
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Color.fromARGB(
                  80,
                  tasks["colorR"][widget.taskIndex],
                  tasks["colorG"][widget.taskIndex],
                  tasks["colorB"][widget.taskIndex]),
              child: Row(
                children: [
                  FloatingActionButton(
                    //create the button which allows users to mark a task as complete
                    //or incomplete
                    onPressed: () {
                      setState(() {
                        if (!complete) {
                          //if incomplete
                          //change to complete
                          complete = true;
                          icon = Icons.check_circle_outline;
                          iconColor = (Colors.white);
                          buttonColor = Color.fromARGB(255, 57, 55, 77);
                        } else {
                          //if complete
                          //change to incomplete
                          complete = false;
                          icon = Icons.circle;
                          iconColor = Colors.grey[300];
                          buttonColor = (Colors.white);
                        }
                        completeTask(
                            complete, widget.tasks["ID"][widget.taskIndex]);
                        print(complete);
                      });
                    },
                    tooltip: 'Complete Task',
                    child: Icon(
                      icon,
                      color: iconColor,
                    ),
                    backgroundColor: buttonColor,
                  ),
                  //just a simple spacer between the button and the text
                  Container(
                    width: 8,
                  ),
                  //display actual task details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                //title, //this is where the title string is used
                                tasks["title"][widget.taskIndex],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              alignment: Alignment.centerRight,
                              child: Text(
                                //this is where the time string is used
                                time,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                //this is where the description string is used
                                tasks["description"][widget.taskIndex],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              alignment: Alignment.centerRight,
                              child: Text(
                                //this is where the date string is used
                                "${tasks["dateTime"][widget.taskIndex].month}/${tasks["dateTime"][widget.taskIndex].day}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.right,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

//some color fields do not accept the Color class
//this converts a Color type to a MaterialColor type which acceptable by all
//color fields
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
