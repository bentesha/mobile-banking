
import 'package:flutter/material.dart';

class ConfirmDialog {

  static Future<bool> show(BuildContext context, String title, String message) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('CANCEL')
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('OK')
            )
          ],
        )
    );
  }

}