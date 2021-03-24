
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {

  ProgressView({this.color});

  final Color color;

  build(context) => Center(
    child: Theme(
      data: Theme.of(context).copyWith(accentColor: color ?? Theme.of(context).accentColor),
      child: CircularProgressIndicator()
    )
  );

}