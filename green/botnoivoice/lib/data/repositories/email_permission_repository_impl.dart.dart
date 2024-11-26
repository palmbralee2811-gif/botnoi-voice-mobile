import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EmailPermissionRepositoryImpl with ChangeNotifier {
  final Logger _logger = Logger();
  bool _isEmailAccessEnabled = true;

  bool get isEmailAccessEnabled => _isEmailAccessEnabled;

  void setEmailAccessEnabled(bool value) {
    _isEmailAccessEnabled = value;
    _logger.d("EmailPermissionProvider -> isEmailAccessEnabled: $_isEmailAccessEnabled");
    notifyListeners();
  }
}
