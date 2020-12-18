//////////////////////////////////////////////////////////////////////////
//The following section contains form builders
//////////////////////////////////////////////////////////////////////////
//The forms are used to create new tasks and edit existing ones.

//sources:
//used thdatetime_picker package to help handle date/time selections
//https://pub.dev/packages/datetime_picker_formfield

import 'package:flutter/material.dart';
import 'sql.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

///Create a Form widget for creating a new task.
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
  String dropdownValue;

  //create a dropdown list for selecting a category in the form
  List<DropdownMenuItem<String>> listToDropMenu(Map categoryNames) {
    List<DropdownMenuItem<String>> menu = [];
    for (int i = 0; i < categoryNames["name"].length; i++) {
      menu.add(DropdownMenuItem<String>(
        value: categoryNames["ID"][i].toString(),
        child: Text(categoryNames["name"][i]),
      ));
    }
    return menu;
  }

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

          //Textfield for inputing a title
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

          //Textfield for inputing a description
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter a description'),
            controller: _descriptionTextController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),

          //Category Selector Field 
          Row(
            children: [
              FutureBuilder(  //categories are dynamically loaded from the dbms
                  future: getCategories(1),
                  builder: (context, projectSnap) {
                    //if no data is returned then don't show field
                    if (!projectSnap.hasData) {
                      print("not showing categories");
                      return Container();
                    } else { //if data is returned...
                      if (dropdownValue == null) {
                        dropdownValue = projectSnap.data["ID"][0].toString();
                      }
                      //display a dropdown
                      return (DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Colors.grey[400],
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              print("category selected: $newValue");
                              dropdownValue = newValue;
                              print("category selected: $dropdownValue");
                            });
                          },
                          items: listToDropMenu(projectSnap.data)));
                    }
                  })
            ],
          ),

          //datetime selector form field
          //shows the calendar picker and the clock time picker
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
            validator: (value) {
              if (value == null) {
                return 'Please enter a time';
              }
              return null;
            },
          ),

          //submit button
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
                  newFormQuery(
                      _titleTextController.text,
                      _descriptionTextController.text,
                      int.parse(dropdownValue),
                      _dateTimeController.text,
                      1);
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

// Create a Form widget for updating an existing task.
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
  String dropdownValue;

  List<DropdownMenuItem<String>> listToDropMenu(Map categoryNames) {
    List<DropdownMenuItem<String>> menu = [];
    for (int i = 0; i < categoryNames["name"].length; i++) {
      menu.add(DropdownMenuItem<String>(
        value: categoryNames["ID"][i].toString(),
        child: Text(categoryNames["name"][i]),
      ));
    }
    return menu;
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  //this initstate field is the reason edit task is largely the same as the new task
  //I dislike douplicate code but it was necessary for the initstate function
  //both look the same but behave very differently
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.tasks["categoryID"][widget.index].toString();
    print("initializing state");
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Textfield for inputing a title
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            //initialValue
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

          //Textfield for inputing a description
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            //initialValue
            controller: _descriptionTextController
              ..text = widget.tasks["description"][widget.index],
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),

          //Category selector field 
          Row(
            children: [
              FutureBuilder(
                  future: getCategories(1),
                  builder: (context, projectSnap) {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (!projectSnap.hasData) {
                      print("not showing categories");
                      return Container();
                    } else {
                      // If the form is valid, display a Snackbar.
                      //print();
                      if (dropdownValue == null) {
                        //dropdownValue =
                        //   widget.tasks["categoryID"][widget.index].toString();
                      }
                      return (DropdownButton<String>(
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: Colors.grey[400],
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              print("category selected: $dropdownValue");
                            });
                          },
                          items: listToDropMenu(projectSnap.data)));
                    }
                  })
            ],
          ),

          //Datetime selector fields
          //shows the calendar picker and the clock time picker
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
            validator: (value) {
              if (value == null) {
                return 'Please enter a title';
              }
              return null;
            },
          ),

          //submit button
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
                  setState(() {
                    updateFormQuery(
                        _titleTextController.text,
                        _descriptionTextController.text,
                        int.parse(dropdownValue),
                        _dateTimeController.text,
                        widget.tasks["ID"][widget.index]);
                    Navigator.pop(context);
                  });
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

class CategorySelectorField extends StatefulWidget {
  CategorySelectorField({this.categoryID});
  final int categoryID;

  @override
  CategorySelectorFieldState createState() {
    return CategorySelectorFieldState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CategorySelectorFieldState extends State<CategorySelectorField> {
  String dropdownValue;

  List<DropdownMenuItem<String>> listToDropMenu(List categoryNames) {
    List<DropdownMenuItem<String>> menu = [];
    for (int i = 0; i < categoryNames.length; i++) {
      menu.add(DropdownMenuItem<String>(
        value: categoryNames[i],
        child: Text(categoryNames[i]),
      ));
    }
    return menu;
  }

  @override
  Widget build(BuildContext context) {
    return (Row(
      children: [
        FutureBuilder(
            future: getCategories(1),
            builder: (context, projectSnap) {
              if (!projectSnap.hasData) {
                print("not showing categories");
                return Container();
              } else {
                if (dropdownValue == null) {
                  dropdownValue = projectSnap.data["name"][0];
                }
                return (DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Colors.grey[400],
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        print("category selected: $newValue");
                        dropdownValue = newValue;
                        print("category selected: $dropdownValue");
                      });
                    },
                    items: listToDropMenu(projectSnap.data["name"])));
              }
            })
      ],
    ));
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
