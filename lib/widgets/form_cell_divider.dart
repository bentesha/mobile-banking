
import 'package:flutter/material.dart';

class FormCellDivider extends StatelessWidget {

  FormCellDivider({this.height = 16});

  final double height;

  build(context) {
    return Divider(height: height);
  }

}