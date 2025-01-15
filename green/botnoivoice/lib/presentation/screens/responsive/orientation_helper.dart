import 'package:flutter/material.dart';

class OrientationHelper {
  static late bool isLandscape;

  static void init(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    isLandscape = orientation == Orientation.landscape;
  }
}
