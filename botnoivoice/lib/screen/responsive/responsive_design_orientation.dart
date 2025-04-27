import 'package:flutter/material.dart';

/// Responsive design orientation using MediaQuery for landscape or portrait
class ResponsiveDesignOrientation {
  static late bool isLandscape;

  static void init(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    isLandscape = orientation == Orientation.landscape;
  }
}
