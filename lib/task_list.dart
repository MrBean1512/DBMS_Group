import 'package:flutter/material.dart';

import "file_handling.dart";

ListView buildTaskList() {
  Map tasks = populateFromJson();
  return (ListView.separated(
    padding: const EdgeInsets.all(8),
    itemCount: 4,
    itemBuilder: (BuildContext context, int index) {
      return buildTaskBox(tasks['title'][index], tasks['description'][index],
          tasks['dateTime'][index]);
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  ));
}

Container buildTaskBox(String title, String description, String dateTime) {
  Container taskBox = Container(
    padding: const EdgeInsets.all(32),
    color: Colors.green[50],
    child: Row(
      children: [
        Icon(
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
                  title, //this is where the title variable is used
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                description, //this is where the description variable is used
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
  return taskBox;
}
