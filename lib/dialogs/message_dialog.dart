import 'package:flutter/material.dart';

class MessageDialog {
  static Future<void> show(
      {BuildContext context, String message, String title}) {
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
                    child: Text('OK'))
              ],
            ));
  }

  static Future<void> showFormError(
          {BuildContext context, String message, String title}) =>
      show(context: context, message: message, title: 'Validation Error');
}
