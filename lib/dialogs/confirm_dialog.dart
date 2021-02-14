
import 'package:flutter/material.dart';

class ConfirmDialog {

  static Future<bool> show(BuildContext context, String title, String message,
      {String okText, String cancelText}) {
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
              child: Text(cancelText ?? 'CANCEL')
            ),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(okText ?? 'OK')
            )
          ],
        )
    );
  }

}