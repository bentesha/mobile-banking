
import 'package:flutter/material.dart';

class PrimaryBackgroundGradient extends LinearGradient {

  PrimaryBackgroundGradient() : super(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
      Color(0xff0a3057),
        Color(0xff338ef9),
        Color(0xff0a3057),
      ]
    );

}