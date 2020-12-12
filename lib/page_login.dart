import 'package:flutter/material.dart';


//this is the agenda page of the app
//it should show a list of upcoming tasks as specified by the user

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  int _counter = 0;

  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'mail:',
          ),
          FloatingActionButton(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
