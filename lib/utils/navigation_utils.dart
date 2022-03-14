import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationUtils {
  static push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  static pushReplacement(BuildContext context, Widget page) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  static pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}