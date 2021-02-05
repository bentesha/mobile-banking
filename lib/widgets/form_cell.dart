

import 'package:flutter/material.dart';

class FormCell extends StatelessWidget {

  FormCell({Key key, @required this.label, @required this.child, this.icon, this.trailing, this.description}) : super(key: key);

  final String label;
  final Widget child;
  final Widget icon;
  final Widget trailing;
  final String description;

  build(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: 16),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Text(label,
                    style: Theme.of(context).textTheme.caption
                ),
                SizedBox(height: 8),
                child,
                [null, ''].contains(description) ? null : Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(description,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12
                      )
                  ),
                )
              ].where((element) => element != null).toList(),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 24),
            child: trailing
        )
      ],
    );
  }

}