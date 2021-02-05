
import 'package:flutter/material.dart';

class MessageDialog {

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK')
          )
        ],
      )
    );
  }

}