
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorView extends StatelessWidget {

  ErrorView(this.message, this.description);

  final String message;
  final String description;

  @override
  build(context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset('assets/error.svg', height: 56, width: 56, color: Theme.of(context).primaryColor),
      SizedBox(height: 16),
      Text('Ups!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
      ),
      SizedBox(height: 8),
      Text(description ?? '')
    ],
  );

}