/*
page_login.dart:
The login page requires users to log into an account before building the app.
Users may enter a username and password which are checked together against the
database. The userId is subsequentially passed in to load content relevant to
only that user.
*/

import 'package:flutter/material.dart';

import 'sql.dart';
import 'page_app.dart';


//create the login page's class
class PageLogin extends StatefulWidget {
  PageLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final _formKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          //show the login form
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                //build widget where the user enters their username
                TextFormField(
                  decoration: InputDecoration(labelText: 'Username'),
                  controller: _usernameTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),

                //build widget where the user enters their password
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  controller: _passwordTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                //build submit button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        //print();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                        //submit the form to the dbms for validation
                        validateLogin(_usernameTextController.text,
                            _passwordTextController.text);
                          //move onto the next page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AppPage(title: widget.title)),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    )));
  }
}
