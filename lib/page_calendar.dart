import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'file_handling.dart';

class PageCalendar extends StatefulWidget {
  PageCalendar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PageCalendarState createState() => _PageCalendarState();
}

class _PageCalendarState extends State<PageCalendar> {

  Future<Map> getEvents() async {
    //convert the map of tasks
    Map tasks = await getMapQuery();
    Map<DateTime, List> events = {};
    DateTime date;
    String event;
    for (var x = 0; x < tasks['dateTime'].length; x++) {
      date = tasks['dateTime'][x];
      date = date.subtract(Duration(hours: date.hour));
      date = date.subtract(Duration(minutes: date.minute));
      date = date.subtract(Duration(seconds: date.second));
      date = date.subtract(Duration(milliseconds: date.millisecond));
      date = date.subtract(Duration(microseconds: date.microsecond));
      
      event = tasks['title'][x];
      if (events[date] == null) {
        events[date] = [event];
      } else {
        events[date].add(event);
      }
      //_events[DateTime.parse(tasks['dateTime'][x])] = [tasks['dateTime'][x]];
      //consider having the loop iterate through tasks instead
    }
    print("events: $events");
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return
        // Displays the score information
        //https://stackoverflow.com/questions/53800662/how-do-i-call-async-property-in-widget-build-method
        //https://stackoverflow.com/questions/52801201/flutter-renderbox-was-not-laid-out for using Expanded with ListView
        Center(
            child: FutureBuilder<Map>(
                future: getEvents(),
                builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                  if (!snapshot.hasData) {
                    print("not showing calendar");
                    return Container();
                  } else {
                    print("snapshot"); //: ${snapshot.data}");
                    return Calendar(events: snapshot.data);
                  }
                }));
  }
}

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};


//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0
//Much of the code in the calendar class is not my own and was copied directly from the
//calendar package creator here: https://pub.dev/packages/table_calendar/example
//there are many modifications throughout the code though

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title, this.events}) : super(key: key);

  final Map events;
  final String title;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  //Map<DateTime, List> _events;
  var _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();

    _events = widget.events;

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekStyle:
          DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.blue[400])),
      calendarStyle: CalendarStyle(
        selectedColor: Colors.lightBlue[400],
        todayColor: Colors.lightBlue[200],
        markersColor: Colors.blue[800],
        weekendStyle: TextStyle(color: Colors.blue[400]), //0xFF2196F3
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.lightBlue[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ), /*
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
        */
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
