
import 'package:flutter/material.dart';

class MessageDialog {

  static Future<void> show(BuildContext context, String message, [String title]) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title == null ? null : Text(title),
        content: Text(message ?? ''),
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