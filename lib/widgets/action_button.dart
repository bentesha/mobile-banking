import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkombozi_mobile/theme/theme.dart';

class ActionButton extends StatelessWidget {
  ActionButton(
      {@required this.caption,
      this.loading = false,
      this.loadingCaption = 'PLEASE WAIT..',
      this.onPressed});

  final String caption;
  final VoidCallback onPressed;
  final String loadingCaption;
  final bool loading;

  @override
  build(context) => InkWell(
        onTap: loading ? null : onPressed,
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 18),
          color: onPressed == null ? Colors.grey.shade500 : AppTheme.primaryColor,
          child: Center(
            child: Text(loading ? loadingCaption : caption,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ),
      );
}
