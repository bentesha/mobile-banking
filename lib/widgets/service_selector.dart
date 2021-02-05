
import 'package:flutter/material.dart';

class ServiceSelector extends StatelessWidget {

  build(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.person),
        SizedBox(width: 16),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Text('Send money to',
                    style: Theme.of(context).textTheme.caption
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset('assets/government-tz.png', height: 32, width: 32),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GePE',
                            style: TextStyle(
                                fontSize: 18
                            )
                        ),
                        Text('Government Services',
                            style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey.shade600)
                        )
                      ],
                    )
                  ],
                )
              ],
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 24),
            child: Icon(Icons.chevron_right)
        )
      ],
    );
  }

}