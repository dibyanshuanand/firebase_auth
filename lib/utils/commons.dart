import 'package:flutter/material.dart';
import 'package:firebase_test/screens/authScreen.dart';

class Commons {

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error Found"),
        content: Text('$message'),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text('$message'),
      action: SnackBarAction(label: 'OK', onPressed: () {
        AuthScreen.scaffoldKey.currentState.hideCurrentSnackBar();
      }),
    );
    AuthScreen.scaffoldKey.currentState.showSnackBar(snackBar);
  }
}