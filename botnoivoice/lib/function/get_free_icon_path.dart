import 'package:flutter/material.dart';

String getFreeIconPath(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;
    switch (languageCode) {
      case 'th':
        return 'assets/images/icon/free-icon-thai.svg';
      case 'en':
        return 'assets/images/icon/free-icon-english.svg';
      case 'id':
        return 'assets/images/icon/free-icon-english.svg';
      default:
        return 'assets/images/icon/free-icon-english.svg';
    }
  }