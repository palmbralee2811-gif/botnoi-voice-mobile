import 'package:flutter/material.dart';

class CreditsProvider with ChangeNotifier {
  String? _remainingCredits;

  String? get remainingCredits => _remainingCredits;

  void setRemainingCredits(String? credits) {
    _remainingCredits = credits;
    notifyListeners();
  }
}