import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  PillButton(
      {@required this.caption,
      this.color,
      this.textColor,
      this.disabledColor,
      this.onPressed});

  final Color color;
  final Color disabledColor;
  final Color textColor;
  final String caption;
  final VoidCallback onPressed;

  @override
  build(context) => SizedBox(
      height: 48,
      width: double.infinity,
      child: RaisedButton(
        onPressed: onPressed,
        child: Text(caption, style: TextStyle(color: textColor)),
        color: color,
        disabledColor: disabledColor,
        shape: StadiumBorder(),
      ));
}
