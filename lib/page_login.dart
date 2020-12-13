//this is the agenda page of the app
//it should show a list of upcoming tasks as specified by the user

import 'package:flutter/material.dart';

import 'file_handling.dart';
import 'app_page.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  int _counter = 0;

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
          //LoginForm(),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                        validateLogin(_usernameTextController.text,
                            _passwordTextController.text);
                        //if(validateLogin(_usernameTextController.text, _passwordTextController.text) >= 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AppPage(title: widget.title)),
                        );
                        //}
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
