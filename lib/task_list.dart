import 'package:flutter/material.dart';

import "file_handling.dart";

//multiple pages implement ListViews so this is used for them all

//builds a listView widget of tasks
ListView buildTaskList(context, _formKey, [String imageFile]) {
  //image is optional
  Map tasks = populateFromJson(); //Map is created from json file
  return (ListView.separated(
    //begin construction of actual widget
    padding: const EdgeInsets.all(8),
    itemCount: 6, //number of widgets to create, used by index

    itemBuilder: (BuildContext context, int index) {
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
          return(
            Container()
          );
      }

      return buildTaskBox(context, _formKey, tasks['title'][index - 1],
          tasks['description'][index - 1], tasks['dateTime'][index - 1]);
      //return statements return only to itemBuilder
    },

    separatorBuilder: (BuildContext context, int index) =>
        const Divider(), //just visually divides task boxes
  ));
}

//builds a taskBox container
//intended to be used by buildTaskList()
InkWell buildTaskBox(context, _formKey, String title, String description, String dateTime) {
  return (InkWell(
    onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
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
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
    child: Container(
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
    )
  ));
}

Form buildForm(_formKey) {
  return(Form(
    key: _formKey,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text("Submitß"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
              }
            },
          ),
        )
      ],
    ),
  ));
}