import 'package:flutter/material.dart';

import 'page_home.dart';
import 'page_calendar.dart';
import 'page_agenda.dart';

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

    pages = [home, calendar, agenda];

    currentPage = home;
    super.initState();
  }

  /* depricated code
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }
  */

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
      ),
      body: currentPage,
      //call the current page to be displayed
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
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: currentTab,
        unselectedItemColor: Colors.green[950],
        selectedItemColor: Colors.grey[200],
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        backgroundColor: Colors.green,
      ),
    );
  }
}