
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/widgets/luku_token_tile.dart';

class LukuTokenListPage extends StatefulWidget {

  static final String routeName = '/luku-tokens';

  @override
  State<StatefulWidget> createState() {
    return _LukuTokenListPageState();
  }

}

class _LukuTokenListPageState extends State<LukuTokenListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Luku Tokens')
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) => InkWell(
            onTap: () {},
            child: LukuTokenTile()
          ),
          separatorBuilder: (context, index) => Divider(height: 1),
        )
      )
    );
  }

}