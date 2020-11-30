import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


//this is the calendar page of the app
//it should show a calendar with upcoming tasks on their respective days
class PageCalendar extends StatelessWidget {
  /*
  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime(DateTime.now().year, DateTime.now().month, 0);
  DateTime lastDate = DateTime(DateTime.now().year, DateTime.now().month+1, 0);
  @override
  Widget build(BuildContext contect) {
    return CalendarDatePicker(
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: selectedDate,
      onDateChanged: ,
    );
  }
  */
  @override
  Widget build(BuildContext contect) {
    return Container(
      height: 300.0,
      color: Colors.green,
    );
  }
}