
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelValueCell extends StatelessWidget {

  LabelValueCell({@required this.label, @required this.value});

  final String label;
  final String value;

  build(context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label ?? '',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.grey.shade600
          )
        ),
        SizedBox(width: 32),
        Expanded(
          child: Text(value ?? '',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,
          )
        )
      ],
    )
  );

}