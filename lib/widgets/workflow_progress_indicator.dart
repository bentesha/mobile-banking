
import 'package:flutter/material.dart';

class WorkflowProgressIndicator extends StatelessWidget {

  WorkflowProgressIndicator(this.description);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(strokeWidth: 2)
        ),
        SizedBox(width: 8),
        Text(description ?? 'Please wait a moment..')
      ],
    );
  }

}