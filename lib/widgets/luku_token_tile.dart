
import 'package:flutter/material.dart';

class LukuTokenTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.money, size: 12),
                  SizedBox(width: 8),
                  Text('24212319040',
                      style: TextStyle(
                          color: Colors.grey.shade600
                      )
                  )
                ],
              ),
              Text('28 Jan 2021 16:44',
                  style: Theme.of(context).textTheme.caption
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('9338 9833 8022 9022 7866',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  )
              ),
              Text('25,000.00',
                  // style: TextStyle(fontWeight: FontWeight.bold)
              )
            ],
          )
        ],
      )
    );
  }

}