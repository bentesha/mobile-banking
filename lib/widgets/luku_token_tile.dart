
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/models/token.dart';

class LukuTokenTile extends StatelessWidget {

  LukuTokenTile(this.token);

  final Token token;

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
                  Text(token.reference,
                      style: TextStyle(
                          color: Colors.grey.shade600
                      )
                  )
                ],
              ),
              Text(token.date,
                  style: Theme.of(context).textTheme.caption
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(token.token,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  )
              ),
              Text(token.amount,
                  // style: TextStyle(fontWeight: FontWeight.bold)
              )
            ],
          )
        ],
      )
    );
  }

}