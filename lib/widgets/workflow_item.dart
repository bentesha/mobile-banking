
import 'package:flutter/material.dart';

abstract class WorkflowItem extends StatelessWidget {

  String get title;

  Future<bool> moveNext(BuildContext context) async => true;

  Future<bool> complete(BuildContext context) async { return false; }
}