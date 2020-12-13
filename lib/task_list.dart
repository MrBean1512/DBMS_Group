//sources:
//used this package to help handle date/time selections
//https://pub.dev/packages/datetime_picker_formfield

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import "file_handling.dart";

//multiple pages implement ListViews so this is used for them all

//builds a listView widget of tasks

FutureBuilder buildTaskList(DateTime start, DateTime end, context, _formKey,
    [String imageFile]) {
  //image is optional
  Map tasks;
  //Map tasks = getMapFromJson(start, end); //Map is created from json file
  return (FutureBuilder(
      future: getMapQuery(start, end),
      builder: (context, projectSnap) {
        /*
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        */
        return (ListView.separated(
          //begin construction of actual widget
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: projectSnap.data.entries.first.value.length + 1,
          //number of widgets to create, used by index
          //this is the same as tasks.entries.first.value.length
          itemBuilder: (context, index) {
            print("index = $index");
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
            return buildTaskBox(context, _formKey, projectSnap.data, index - 1);
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

// Create a Form widget.
class NewTaskForm extends StatefulWidget {
  @override
  NewTaskFormState createState() {
    return NewTaskFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewTaskFormState extends State<NewTaskForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<NewTaskFormState>.
  final _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _dateTimeController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter a title'),
            controller: _titleTextController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter a description'),
            controller: _descriptionTextController,
          ),
          DateTimeField(
            //The code in the DateTimeField() was coppied from the
            //datetime_picker_form package'spage mentioned in the sources at the
            //top of this page above and only slight alterations have been made
            //to accomodate formatting this class is form field for choosing a
            //dateTime dart's standard dateTime form field is not user friendly
            //at all
            decoration: InputDecoration(labelText: 'Select date and time'),
            controller: _dateTimeController,
            format: DateFormat("yyyy-MM-dd HH:mm"),
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  //print();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  print("title: ${_titleTextController.text}");
                  print("description: ${_descriptionTextController.text}");
                  print("dateTime: ${_dateTimeController.text}");
                  newFormQuery(_titleTextController.text, _descriptionTextController.text, 1, _dateTimeController.text, 1);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a Form widget.
class EditTaskForm extends StatefulWidget {
  EditTaskForm(this.tasks, this.index);
  final Map tasks;
  final int index;

  @override
  EditTaskFormState createState() {
    return EditTaskFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class EditTaskFormState extends State<EditTaskForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<EditTaskFormState>.
  final _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _dateTimeController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            //initialValue: widget.tasks["title"][widget.index],
            controller: _titleTextController
              ..text = widget.tasks["title"][widget.index],
            //controller must be null if an initialValue is specified
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            //initialValue: widget.tasks["description"][widget.index],
            controller: _descriptionTextController
              ..text = widget.tasks["description"][widget.index],
          ),
          DateTimeField(
            //The code in the DateTimeField() was coppied from the
            //datetime_picker_form package'spage mentioned in the sources at the
            //top of this page above and only slight alterations have been made
            //to accomodate formatting this class is form field for choosing a
            //dateTime dart's standard dateTime form field is not user friendly
            //at all
            decoration: InputDecoration(labelText: 'Date and Time'),
            //initialValue: widget.tasks["dateTime"][widget.index],
            controller: _dateTimeController
              ..text = widget.tasks["dateTime"][widget.index].toString(),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  //print();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  print("title: ${_titleTextController.text}");
                  print("description: ${_descriptionTextController.text}");
                  print("dateTime: ${_dateTimeController.text}");
                  
                  updateFormQuery(_titleTextController.text, _descriptionTextController.text, 1, _dateTimeController.text, widget.tasks["ID"][widget.index]);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit Changes'),
            ),
          ),
        ],
      ),
    );
  }
}

//Following class's code was coppied from the datetime_picker_form package's
//page mentioned in the sources above and only slight alterations have been made
//to accomodate formatting
//this class is form field for choosing a dateTime
//dart's standard dateTime form field is not user firendly at all
class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        decoration: InputDecoration(labelText: 'Select date and time'),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
      Icon(Icons.arrow_drop_down),
    ]);
  }
}
