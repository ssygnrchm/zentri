import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text){
  final snackBar = SnackBar(
    content: Text(text),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}