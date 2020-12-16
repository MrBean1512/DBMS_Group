import 'package:flutter/material.dart';

import 'page_home.dart';
import 'page_calendar.dart';
import 'page_agenda.dart';
import 'forms.dart';
import 'task_list.dart';

class AppPage extends StatefulWidget {
  AppPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  //simple stateful interactions are now handled within their respective widget
  int setStateIncrement = 0;
  int currentTab = 0;

  PageHome home;
  PageCalendar calendar;
  PageAgenda agenda;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    home = PageHome();
    calendar = PageCalendar();
    agenda = PageAgenda();

    pages = [
      home,
      calendar,
      agenda,
    ];

    currentPage = home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the AppPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        
        //title: Text('$mail')
      ),
      body: currentPage,

      //call the current page to be displayed
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        NewTaskForm(),
                      ],
                    ),
                  );
                });
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 108, 95, 255),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //navigation bar along the bottom of the app
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Agenda',
          ),
          //BottomNavigationBarItem(
          //  icon: Icon(Icons.login),
          //  label: 'Login',
          //),
        ],
        currentIndex: currentTab,
        unselectedItemColor: Colors.grey[400],
        selectedItemColor: Colors.grey[200],
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        backgroundColor: Color.fromARGB(255, 57, 55, 77),
      ),
    );
  }
}
