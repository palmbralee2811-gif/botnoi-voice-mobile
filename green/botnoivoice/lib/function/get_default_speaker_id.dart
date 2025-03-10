import 'package:flutter/material.dart';

String getDefaultSpeakerId(BuildContext context) {
  String languageCode = Localizations.localeOf(context).languageCode;
  languageCode = languageCode.isNotEmpty ? languageCode : 'en';
  switch (languageCode) {
    case 'th':
      return '1';
    case 'en':
      return '9';
    case 'id':
      return '65';
    default:
      return '9';
  }
}
